

import RPi.GPIO as GPIO
GPIO.setwarnings(False)

import os, time


m1_1 = 8
m1_2 = 11
m2_1 = 14 
m2_2 = 15 
cam_light = 17
headlight_right = 18
headlight_left = 27 
sp_light=9 


def init_gpio():
	GPIO.setmode(GPIO.BCM)
	GPIO.setup(m1_1,GPIO.OUT)
	GPIO.setup(m1_2,GPIO.OUT)
	GPIO.setup(m2_1,GPIO.OUT)
	GPIO.setup(m2_2,GPIO.OUT)
	

def back():
    print("moving back!!!!!!")
    GPIO.output(m1_1, False)
    GPIO.output(m1_2, True)
    GPIO.output(m2_1, True)
    GPIO.output(m2_2, False)
    
def right():
	GPIO.output(m1_1, True)
	GPIO.output(m1_2, False)
	GPIO.output(m2_1, True)
	GPIO.output(m2_2, False)

def left():
	GPIO.output(m1_1, False)
	GPIO.output(m1_2, True)
	GPIO.output(m2_1, False)
	GPIO.output(m2_2, True)
	
def forward():
	GPIO.output(m1_1, True)
	GPIO.output(m1_2, False)
	GPIO.output(m2_1, False)
	GPIO.output(m2_2, True)
	
def stop():
	GPIO.output(m1_1, False)
	GPIO.output(m1_2, False)
	GPIO.output(m2_1, False)
	GPIO.output(m2_2, False)

