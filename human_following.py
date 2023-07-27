
import common1 as cm
import cv2
import numpy as np
from PIL import Image
import time
from threading import Thread

import sys
sys.path.insert(0, '/')
import util as ut
ut.init_gpio()

cap = cv2.VideoCapture(0) #capturing video from pi camera
threshold=0.2 
top_k=5 
model_dir = ' '
model = 'mobilenet_ssd_v2_coco_quant_postprocess.tflite'  #mobile net tensorflow model 
lbl = 'coco_labels.txt' #list of labels

tol=0.1
x_dev=0
y_maximum=0
arr=[0,0,0,0,0,0]

object_to_track='person'

#flask app for video streaming
from flask import Flask, Response
from flask import render_template

app = Flask(__name__)

@app.route('/')
def index():
    #return "Default Message"
    return render_template("index.html")

@app.route('/video_feed')
def video_feed():
    #global cap
    return Response(main(),
                    mimetype='multipart/x-mixed-replace; boundary=frame')
                    

import RPi.GPIO as GPIO 
GPIO.setmode(GPIO.BCM)      
GPIO.setup(20, GPIO.OUT)
GPIO.setup(21, GPIO.OUT)
pin20 = GPIO.PWM(20, 100)    
pin21 = GPIO.PWM(21, 100)    
val=100
pin20.start(val)               
pin21.start(val)             
    
print("speed set to: ", val)

def track_object(objs,labels):
   
    global x_dev, y_maximum, tol, arr
    
    if(len(objs)==0):
        print("no objects to track")
        ut.stop()
        arr=[0,0,0,0,0,0]
        return
    
    flag=0
    for obj in objs:
        lbl=labels.get(obj.id, obj.id)
        if (lbl==object_to_track):
            x_min, y_min, x_max, y_maximum = list(obj.bbox)
            flag=1
            break
        
    #print(x_min, y_min, x_max, y_maximum)
    if(flag==0):
        print("selected object no present")
        return
        
    x_diff=x_max-x_min
    y_diff=y_maximum-y_min
    print("x_diff: ",round(x_diff,5))
    print("y_diff: ",round(y_diff,5))
        
        
    obj_x_center=x_min+(x_diff/2)
    obj_x_center=round(obj_x_center,3)
    
    obj_y_center=y_min+(y_diff/2)
    obj_y_center=round(obj_y_center,3)
            
    x_dev=round(0.5-obj_x_center,3)
    y_maximum=round(y_maximum,3)
        
    print("{",x_dev,y_maximum,"}")
   
    thread = Thread(target = move_robot)
    thread.start()
    
    arr[0]=obj_x_center
    arr[1]=obj_y_center
    arr[2]=x_dev
    arr[3]=y_maximum
    

def move_robot():
    global x_dev, y_maximum, tol, arr
    
    print("moving robot .............!!!!!!!!!!!!!!")
    print(x_dev, tol, arr)
    
    y=1-y_maximum #distance from bottom of the frame
    
    if(abs(x_dev)<tol):
        delay1=0
        if(y<0.1):
            cmd="Stop"
            ut.stop()
        else:
            cmd="forward"
            ut.forward()
    
    else:
        if(x_dev>=tol):
            cmd="Move Left"
            delay1=get_delay(x_dev)
                
            ut.left()
            time.sleep(delay1)
            ut.stop()
                
        if(x_dev<=-1*tol):
            cmd="Move Right"
            delay1=get_delay(x_dev)
                
            ut.right()
            time.sleep(delay1)
            ut.stop()

    arr[4]=cmd
    arr[5]=delay1

def get_delay(dev):
    dev=abs(dev)
    if(dev>=0.4):
        d=0.080
    elif(dev>=0.35 and dev<0.40):
        d=0.060
    elif(dev>=0.20 and dev<0.35):
        d=0.050
    else:
        d=0.040
    return d
    
def main():
        
    interpreter, labels =cm.load_model(model_dir,model,lbl)#loading tensorflow model
    
    fps=1
    arr_dur=[0,0,0]
    
    while True:
        start_time=time.time()

        start_t0=time.time()
        ret, frame = cap.read()
        if not ret:
            break
        
        img = frame
        img = cv2.flip(img, 0)
        img = cv2.flip(img, 1)

        img_rgb = cv2.cvtColor(img, cv2.COLOR_BGR2RGB)
        pil_im = Image.fromarray(img_rgb)
       
        arr_dur[0]=time.time() - start_t0

        start_t1=time.time()
        cm.set_input(interpreter, pil_im)
        interpreter.invoke()
        objs = cm.get_output(interpreter, score_threshold=threshold, top_k=top_k)
        
        arr_dur[1]=time.time() - start_t1
        start_t2=time.time()
        track_object(objs,labels)
       
        if cv2.waitKey(1) & 0xFF == ord('q'):
            break
 
        img = append_text_img1(img, objs, labels, arr_dur, arr)
        
        ret, jpeg = cv2.imencode('.jpg', img)
        pic = jpeg.tobytes()
        
        #Streaming flask
        yield (b'--frame\r\n'b'Content-Type: image/jpeg\r\n\r\n' + pic + b'\r\n\r\n')
       
        arr_dur[2]=time.time() - start_t2
        fps = round(1.0 / (time.time() - start_time),1)
        print("*********FPS: ",fps,"************")

    cap.release()
    cv2.destroyAllWindows()

def append_text_img1(img, objs, labels, arr_dur, arr):
    height, width, channels = img.shape
    font=cv2.FONT_HERSHEY_SIMPLEX
    
    global tol
    
    #draw black rectangle on top
    img = cv2.rectangle(img, (0,0), (width, 24), (0,0,0), -1)
   
    #write processing durations
    cam=round(arr_dur[0]*1000,0)
    inference=round(arr_dur[1]*1000,0)
    other=round(arr_dur[2]*1000,0)
    text_dur = 'Camera: {}ms   Inference: {}ms   other: {}ms'.format(cam,inference,other)
    img = cv2.putText(img, text_dur, (int(width/4)-30, 16),font, 0.4, (255, 255, 255), 1)
    
    total_duration=cam+inference+other
    fps=round(1000/total_duration,1)#finding frame rate
    text1 = 'FPS: {}'.format(fps)
    img = cv2.putText(img, text1, (10, 20),font, 0.7, (150, 150, 255), 2)
   
    img = cv2.rectangle(img, (0,height-24), (width, height), (0,0,0), -1)
    
    str_tol='Tol : {}'.format(tol)
    img = cv2.putText(img, str_tol, (10, height-8),font, 0.55, (150, 150, 255), 2)
  
    x_dev=arr[2]
    str_x='X: {}'.format(x_dev)
    if(abs(x_dev)<tol):
        color_x=(0,255,0)
    else:
        color_x=(0,0,255)
    img = cv2.putText(img, str_x, (110, height-8),font, 0.55, color_x, 2)
    
    y_dev=arr[3]
    str_y='Y: {}'.format(y_dev)
    if(abs(y_dev)>0.9):
        color_y=(0,255,0)
    else:
        color_y=(0,0,255)
    img = cv2.putText(img, str_y, (220, height-8),font, 0.55, color_y, 2)
   
    cmd=arr[4]
    img = cv2.putText(img, str(cmd), (int(width/2) + 10, height-8),font, 0.68, (0, 255, 255), 2)
    
    delay1=arr[5]
    str_sp='Speed: {}%'.format(round(delay1/(0.1)*100,1))
    img = cv2.putText(img, str_sp, (int(width/2) + 185, height-8),font, 0.55, (150, 150, 255), 2)#display needed speed values
    
    #display the results of tracking in command line
    if(cmd==0):
        str1="No object"
    elif(cmd=='Stop'):
        str1='Acquired'
    else:
        str1='Tracking'

    #inserting bounding boxes and centers
    img = cv2.putText(img, str1, (width-140, 18),font, 0.7, (0, 255, 255), 2) 
    img = cv2.rectangle(img, (0,int(height/2)-1), (width, int(height/2)+1), (255,0,0), -1)
    img = cv2.rectangle(img, (int(width/2)-1,0), (int(width/2)+1,height), (255,0,0), -1)   
    img = cv2.circle(img, (int(arr[0]*width),int(arr[1]*height)), 7, (0,0,255), -1)
    img = cv2.rectangle(img, (int(width/2-tol*width),0), (int(width/2+tol*width),height), (0,255,0), 2)
    
    for obj in objs:
        x0, y0, x1, y1 = list(obj.bbox)
        x0, y0, x1, y1 = int(x0*width), int(y0*height), int(x1*width), int(y1*height)
        percent = int(100 * obj.score)
        
        box_color, text_color, thickness=(0,150,255), (0,255,0),1
        

        text3 = '{}% {}'.format(percent, labels.get(obj.id, obj.id))
        
        if(labels.get(obj.id, obj.id)=="person"):
            img = cv2.rectangle(img, (x0, y0), (x1, y1), box_color, thickness)
            img = cv2.putText(img, text3, (x0, y1-5),font, 0.5, text_color, thickness)
            
    return img

#running flask
if __name__ == '__main__':
    app.run(host='0.0.0.0', port=2204, threaded=True) # Run FLASK
    main()