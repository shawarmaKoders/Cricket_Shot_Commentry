import os
import time
from moviepy.editor import AudioFileClip, VideoFileClip


def convert_video_to_audio(video_file: str):
    clip = VideoFileClip(video_file)
    pre, ext = os.path.splitext(video_file)
    audio_file = pre + '.mp3'
    clip.audio.write_audiofile(audio_file)


def merge_audio_video(audio_file: str, video_file: str):
    audio_clip = AudioFileClip(audio_file)
    video_clip = VideoFileClip(video_file)

    # audio_clip.duration = video_clip.duration
    audio_clip = audio_clip.subclip(0, video_clip.duration)
    video_clip.audio = audio_clip

    return video_clip


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
out_vid = merge_audio_video('test_audio.mp3', f'clips/{shot}/{shot}{shot_number}.mp4')
save_audio_video_file(out_vid)
