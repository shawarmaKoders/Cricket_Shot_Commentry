import os
import time
from moviepy.editor import AudioFileClip, VideoFileClip, concatenate_videoclips

import cv2


def convert_video_to_audio(video_file: str):
    clip = VideoFileClip(video_file)
    pre, ext = os.path.splitext(video_file)
    audio_file = pre + '.mp3'
    clip.audio.write_audiofile(audio_file)


def starting_point_in_time(video_file_name: str, frame_number: int):
    video = cv2.VideoCapture(video_file_name)
    video_fps = video.get(cv2.CAP_PROP_FPS)
    start_time = frame_number / video_fps - 1
    return start_time, video_fps


def merge_audio_video(audio_file: str, video_file: str, frame_number: int = 0):
    audio_clip = AudioFileClip(audio_file)
    video_clip = VideoFileClip(video_file)

    start_time, video_fps = starting_point_in_time(video_file, frame_number)

    # audio_clip.duration = video_clip.duration
    orig_video_duration = video_clip.duration
    orig_audio_duration = audio_clip.duration

    audio_clip = audio_clip.subclip(0, min(orig_video_duration - start_time, orig_audio_duration))

    first_part = video_clip.subclip(0, start_time)
    second_part = video_clip.subclip(start_time, orig_video_duration)

    second_part.audio = audio_clip

    final_video_clip = concatenate_videoclips([first_part, second_part])
    return final_video_clip


def save_audio_video_file(video_clip: VideoFileClip, output_dir='final_ouput', filename=None):
    if not filename:
        if not os.path.exists(output_dir):
            os.makedirs(output_dir)
        time_string = time.strftime("%Y%m%d_%H%M%S") + '.mp4'
        write_file_path = os.path.join(output_dir, time_string)
    else:
        write_file_path = filename
    video_clip.write_videofile(write_file_path)
    return write_file_path


# convert_video_to_audio('test_audio.mp4')
shot = 'pull'
shot_number = 1
audio_file_number = 1
out_vid = merge_audio_video(f'audio_clips/{shot}/{shot}{audio_file_number}.mpeg',
                            f'clips/{shot}/{shot}{shot_number}.mp4', 45)
save_audio_video_file(out_vid)
