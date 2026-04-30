# APOD Demo Project

A  iOS app that displays NASA's Astronomy Picture(or Video) of the Day.

Built with SwiftUI using MVVM architecture.

---

## Demo

- Screenshot

![image](https://github.com/WeiTsungCheng/APOD_demo_project/blob/main/demo/screenshot.png)

- Video

Click to watch:
https://github.com/WeiTsungCheng/APOD_demo_project/blob/main/demo/video.mov

---

## Features

- Load today's APOD on launch
- Select different dates
- Support both image and video content
- Cache the last successful result
- Fallback to cache when network fails

---

## Cache Behavior

- Only the **last successful APOD** is cached
- Includes both model and image
- If the API fails, cached data is shown
- Cache is tied to the selected date to avoid mismatch

---

## API Key Setup

This project requires a NASA API key.

1. Copy the example file:
```
cp Secrets.example.xcconfig Secrets.xcconfig
```

2. Add your API key:
```
NASA_API_KEY = YOUR_API_KEY
```
Get a key here: https://api.nasa.gov/

---

## Tech

- SwiftUI
- MVVM
- async/await
- URLSession
- UserDefaults + FileManager (cache)

---

## Notes

- Uses system colors → supports Dark Mode automatically
- Handles async race conditions when switching dates
- No third-party libraries
