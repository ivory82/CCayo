# Claude Code Usage Monitoring + SwiftBar Integration

![Usage Screenshot](images/screenshot.png)

As I kept using Claude Code, I became more sensitive to usage.

When using the Opus model, tokens run out 5x faster than Sonet,
so it’s important to keep an eye on how much I’m using within the 5-hour reset cycle.

## 1. Install SwiftBar

https://github.com/swiftbar/SwiftBar
I found that you need an app called SwiftBar to display information in the top status bar.

## 2. Install ccusage
[ccusage](https://github.com/ryoppippi/ccusage)  

## 3. Download the sh file, then adjust plan and folder path
CCUSAGE="${CCUSAGE_CMD:-/Users/USER_NAME/.nvm/versions/node/v20.19.4/bin/ccusage}"
BLOCK_LIMIT="${BLOCK_LIMIT_TOKENS:-88000}"

# Claude Code 사용량 모니터링 + SwiftBar 연동
![Usage Screenshot](images/screenshot.png)
클로드 코드를 계속 사용하다 보니 사용량에 좀 민감해졌다.  

모델을 **Opus**를 쓰면 **Sonet**에 비해 토큰이 **5배 빨리 닳기 때문에**,  
5시간 리셋 주기에 맞춰서 내가 얼마나 쓰고 있는지 눈여겨볼 필요가 있다.  

## 1.SwiftBar 설치

https://github.com/swiftbar/SwiftBar
찾아보니 **SwiftBar**라는 앱이 있어야 상단 스테이터스바에 뭔가 보여줄수 있다 .

## 2.`ccusage` 설치
[ccusage](https://github.com/ryoppippi/ccusage)  


## 3. sh파일 다운로드 후 플랜 및 폴더 위치 수정후 연결
CCUSAGE="${CCUSAGE_CMD:-/Users/USER_NAME/.nvm/versions/node/v20.19.4/bin/ccusage}"
BLOCK_LIMIT="${BLOCK_LIMIT_TOKENS:-88000}"

