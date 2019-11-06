import numpy as np
import os
import cv2

shotType = 'straight'
for video_number in range(1, 5):
    print('------------------------------------------')
    print('------------------------------------------')
    filename = f'{shotType}{video_number}.mp4'
    video_file = os.path.join('clips', shotType, filename)
    print(video_file)

    video = cv2.VideoCapture(video_file)

    video_frames = video.get(cv2.CAP_PROP_FRAME_COUNT)
    print("Total Frames:", video_frames)

    video_fps = video.get(cv2.CAP_PROP_FPS)
    print(f'FPS: {video_fps}')

    video_duration = video_frames / video_fps
    print(f'Duration: {video_duration}s')

    video_height = video.get(cv2.CAP_PROP_FRAME_HEIGHT)
    video_width = video.get(cv2.CAP_PROP_FRAME_WIDTH)
    print(f'Height x Width: {video_height} x {video_width}')

    FPS_REDUCE_FACTOR = 0.2
    fps_delta = int(video_fps * FPS_REDUCE_FACTOR)

    print()

    total_frames_processed = 0

    while video.isOpened():
        current_frame_position = int(video.get(cv2.CAP_PROP_POS_FRAMES))
        print('Frame Number:', current_frame_position)
        ret, frame = video.read()

        if frame is None:
            break

        gray = cv2.cvtColor(frame, cv2.COLOR_BGR2GRAY)

        cv2.imshow(f'{shotType}', gray)
        total_frames_processed += 1

        if cv2.waitKey(1) & 0xFF == ord('q'):
            print(frame.shape)
            break

        video.set(cv2.CAP_PROP_POS_FRAMES, current_frame_position + fps_delta)

    print('Total Frames Processed:', total_frames_processed)

    video.release()
    cv2.destroyAllWindows()
