import numpy as np
import cv2

cap = cv2.VideoCapture('filename.mp4')

while(cap.isOpened()):
    ret, frame = cap.read()

    gray = cv2.cvtColor(frame, cv2.COLOR_BGR2GRAY)

    cv2.imshow('Shot Name', frame)
    if cv2.waitKey(1) & 0xFF == ord('q'):
        print(frame.shape)
        break

cap.release()
cv2.destroyAllWindows()