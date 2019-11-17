from pandas import DataFrame, concat
from numpy import rot90
import subprocess
import os
import cv2
import sys

if __name__ == "__main__":
    print('------------------------------------------')
    print('------------------------------------------')
    try:
        video_file_name = sys.argv[1]
        video_name = os.path.basename(video_file_name)
    except:
        print('Error: Expected video name')
    video_file = os.path.join('video_clips', video_file_name)
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
    frames_to_cover = video_frames // 2
    df = None

    while video.isOpened():
        current_frame_position = int(video.get(cv2.CAP_PROP_POS_FRAMES))
        print('Frame Number:', current_frame_position)
        ret, frame = video.read()

        if frame is None:
            break

        gray = cv2.cvtColor(frame, cv2.COLOR_BGR2GRAY)

        cv2.imshow(video_name, gray)
        total_frames_processed += 1

        dim = (100, 100)
        resized_gray = cv2.resize(gray, dim)
        resized_gray_rotated = rot90(resized_gray, 1)
        df_gray = DataFrame(resized_gray_rotated)
        if df is not None:
            df = concat([df, df_gray])
        else:
            df = df_gray
        if current_frame_position > frames_to_cover:
            break

        if cv2.waitKey(1) & 0xFF == ord('q'):
            break

        video.set(cv2.CAP_PROP_POS_FRAMES, current_frame_position + fps_delta)

    print('Total Frames Processed:', total_frames_processed)
    print(df)

    image_frame_csv_output_dir = 'image_frames_csvs'
    if not os.path.exists(image_frame_csv_output_dir):
        os.makedirs(image_frame_csv_output_dir)

    file_name_without_ext = os.path.splitext(video_name)[0]
    out_csv_name = f'{file_name_without_ext}.csv'
    write_file_path = os.path.join(image_frame_csv_output_dir, out_csv_name)
    df.to_csv(write_file_path, index=False, header=False)

    classification_csv_output_dir = 'classification_csvs'
    if not os.path.exists(classification_csv_output_dir):
        os.makedirs(classification_csv_output_dir)

    video.release()
    cv2.destroyAllWindows()

    r_model_path = os.path.join('..', 'CNN', 'load_model.R')
    print('R Model Path:', r_model_path)
    r_model_execution = subprocess.Popen(['Rscript', r_model_path, video_name])
