# 메뉴판 사용법

## 데이터 올리기
 - `public/data/` 위치에 **CSV**로 변환한 파일을 업로드

## 설정하기
 - `public/data/setting.json`에서 모든 항목을 세팅할 수 있음
    - `datafileName`: 데이터 파일 이름 (확장자 포함)
       - **데이터 파일은 반드시 csv 확장자로 업로드 해야 함!**
    - `fontfileName`: 폰트 파일 이름 (확장자 포함)
    - `productNameIndex`: **제품명** 열 번호 
    - `categoryIndex`: **카테고리** 열 번호
    - `qtIndex`: **수량** 열 번호
    - `displayPriceIndex`: **매장시음 판매가** 열 번호
    - `inorder`: 카테고리 정렬 (true: 오름차순, false: 내림차순)
    - `titleFontsize`: 카테고리 폰트 크기(pt)
    - `itemFontsize`: 내용 폰트 크기(pt)
    - `leftRightMobileMargin`: 모바일 좌우 마진 크기
    - `leftRightPCMargin`: PC 또는 태블릿 좌우 마진 크기
    - `lineSpacing`: 줄간격
    - `mobileMaxWidth`: 사용자 화면 너비가 여기에 정한 픽셀 이상이 되면 PC로 인식
 - 설정값 변경 이후, 5분 대기 후 새로고침 혹은 다른 기기 접속 시 정상반영
 - 만약, 설정 만진 후 흰화면만 보인다면 너가 잘못한 것이기 때문에 확인할 것 ~~(연락 안받을거)~~