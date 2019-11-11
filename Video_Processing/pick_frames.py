from pandas import DataFrame, concat
from numpy import rot90
import os
import cv2
import sys

if __name__ == "__main__":
    print('------------------------------------------')
    print('------------------------------------------')
    try:
        shotType = sys.argv[1]
    except:
        print('Expected shot directory')
    try:
        video_number = int(sys.argv[2])
    except:
        print("Expected a video number")
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

    FPS_REDUCE_FACTOR = 0.1
    fps_delta = max(1, int(video_fps * FPS_REDUCE_FACTOR))

    print()

    total_frames_processed = 0
    df = None

    while video.isOpened():
        current_frame_position = int(video.get(cv2.CAP_PROP_POS_FRAMES))
        print('Frame Number:', current_frame_position)
        ret, frame = video.read()

        if frame is None:
            break

        gray = cv2.cvtColor(frame, cv2.COLOR_BGR2GRAY)

        cv2.imshow(f'{shotType}', gray)
        total_frames_processed += 1

        dim = (100, 100)
        resized_gray = cv2.resize(gray, dim)
        resized_gray_rotated = rot90(resized_gray, 1)
        df_gray = DataFrame(resized_gray_rotated)
        if df is not None:
            df = concat([df, df_gray])
        else:
            df = df_gray

        if cv2.waitKey(1) & 0xFF == ord('q'):
            break

        video.set(cv2.CAP_PROP_POS_FRAMES, current_frame_position + fps_delta)

    print('Total Frames Processed:', total_frames_processed)
    print(df)
    output_dir = 'image_frames_csvs'
    if not os.path.exists(output_dir):
        os.makedirs(output_dir)
    out_csv_name = f'{shotType}_{video_number}.csv'
    write_file_path = os.path.join(output_dir, out_csv_name)
    df.to_csv(write_file_path, index=False, header=False)

    video.release()
    cv2.destroyAllWindows()
