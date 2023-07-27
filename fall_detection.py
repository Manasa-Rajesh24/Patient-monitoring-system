import cv2
import time

fitToEllipse = False
cap = cv2.VideoCapture(0)
time.sleep(2)

fb = cv2.createBackgroundSubtractorMOG2()
j = 0

while(1):
    ret, frame = cap.read()
    
    
    try:
        gray = cv2.cvtColor(frame, cv2.COLOR_BGR2GRAY)
        fmask = fb.apply(gray)
        
        
        contours, _ = cv2.findContours(fmask, cv2.RETR_TREE, cv2.CHAIN_APPROX_SIMPLE)

        if contours:
        
            
            areas = []

            for contour in contours:
                ar = cv2.contourArea(contour)
                areas.append(ar)
            
            maxarea = max(areas, default = 0)

            maxarea_index = areas.index(maxarea)

            cnt = contours[maxarea_index]

            M = cv2.moments(cnt)
            
            x, y, w, h = cv2.boundingRect(cnt)

            cv2.drawContours(fmask, [cnt], 0, (255,255,255), 3, maxLevel = 0)
            
            if h < w:
                k += 1
                
            if k > 10:
                print("FALL")
                cv2.putText(fmask, 'FALL', (x, y), cv2.FONT_HERSHEY_TRIPLEX, 0.5, (255,255,255), 2)
                cv2.rectangle(frame,(x,y),(x+w,y+h),(0,0,255),2)

            if h > w:
                k = 0 
                cv2.rectangle(frame,(x,y),(x+w,y+h),(0,255,0),2)


            cv2.imshow('video', frame)
        
            if cv2.waitKey(33) == 27:
             break
    except Exception as e:
        break
cv2.destroyAllWindows()