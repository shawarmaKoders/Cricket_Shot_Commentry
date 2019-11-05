import os
import time
from moviepy.editor import AudioFileClip, VideoFileClip


def convert_video_to_audio(video_file: str):
    clip = VideoFileClip(video_file)
    pre, ext = os.path.splitext(video_file)
    audio_file = pre + '.mp3'
    clip.audio.write_audiofile(audio_file)


def merge_audio_video(audio_file: str, video_file: str):
    # import pdb
    # pdb.set_trace()
    audio_clip = AudioFileClip(audio_file)
    video_clip = VideoFileClip(video_file, audio=False)

    video_clip.set_audio(audio_clip)
    return video_clip


def save_audio_video_file(video_clip: VideoFileClip, output_dir='final_ouput', filename=None):
    if not filename:
        time_string = time.strftime("%Y%m%d_%H%M%S") + '.mp4'
        write_file_path = os.path.join(output_dir, time_string)
    else:
        write_file_path = filename
    video_clip.write_videofile(write_file_path)
    return write_file_path


# convert_video_to_audio('test_audio.mp4')
shot = 'straight'
shot_number = 2
out_vid = merge_audio_video('test_audio.mp3', f'clips/{shot}/{shot}{shot_number}.mp4')
save_audio_video_file(out_vid, filename='abc.mp4')
