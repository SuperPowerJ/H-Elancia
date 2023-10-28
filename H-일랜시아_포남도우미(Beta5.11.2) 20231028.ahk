;-----------------------------------------------------
;제작자: DCINSIDE 일랜시아 갤러리의 압둘핫산
;프로젝트명: H-Elancia
;최초작성일: 2023년 6월 17일
;수정일: 2023년 9월 1일
;버젼정보: Beta 5.11.1
;-----------------------------------------------------

;배포를 위해 일부 악용 할 수 있는 코드가 삭제되었습니다.
;배포일 2023년 10월 28일

Global ThisWindowTitle := "일랜시아매크로"

if not A_IsAdmin {
MsgBox, 관리자 권한으로 실행해주세요
ExitApp
}

#SingleInstance, off
#NoEnv
#Persistent
#KeyHistory 0
;#NoTrayIcon
#Warn All, Off

ListLines, OFF
DetectHiddenText, On
DetectHiddenWindows, On
CoordMode, Mouse, Client
CoordMode, pixel, Client
SetWinDelay, 0
SetControlDelay, 0
SetKeyDelay, -1
SetMouseDelay, -1
SetDefaultMouseSpeed, 0
SetTitleMatchMode,3
SetBatchLines, -1

;-------------------------------------------------------
;-------초기값 설정부------------------------------------
;-------------------------------------------------------

;옵션 리스트 구분
Global Lists := [ "CheckBoxList", "DropDownList", "EditList", "RadioButton" ]
;사용된 옵션들
Global CheckBoxList := ["자동재접속사용여부","힐링포션사용여부", "HP마을귀환사용여부", "리메듐사용여부", "마나포션사용여부", "MP마을귀환사용여부", "브렐사용여부", "식빵사용여부", "식빵구매여부", "골드바판매여부", "골드바구매여부", "대화사용", "명상사용", "더블어택사용", "체력향상사용", "민첩향상사용", "활방어사용", "마력향상사용", "마법방어향상사용", "3번", "4번", "5번", "6번", "7번", "8번", "은행넣기활성화", "소각활성화","아템먹기여부","자동이동여부", "훔치기사용", "훔쳐보기사용", "Sense사용", "자동사냥여부", "무기사용여부","특오자동교환여부","행깃구매여부","라깃구매여부","독침사용","현혹사용","폭검사용","무기공격사용","집중사용","회피사용","몸통찌르기사용","리메듐사용","라리메듐사용","엘리메듐사용","쿠로사용","빛의갑옷사용","공포보호사용","다라사용","브렐사용","브레마사용","물의갑옷사용","감속사용","마스사용","라크사용","번개사용","브리스사용","파스티사용","슈키사용","클리드사용","스톤스킨사용","파라스사용","베네피쿠스사용","저주사용","자동파티여부", "포레스트네자동대화"]
Global SpellList := ["리메듐","라리메듐","엘리메듐","쿠로","빛의갑옷","공포보호","다라","브렐","브레마","물의갑옷","감속","마스","라크","번개","브리스","파스티","슈키","클리드","스톤스킨","파라스","베네피쿠스","저주"]
Global DropDownList := ["메인캐릭터서버", "메인캐릭터순서", "힐링포션사용단축키", "마나포션사용단축키", "식빵사용단축키", "식빵구매마을" ,"지침서", "오란의깃사용단축키"]
Global EditList := ["힐링포션사용제한", "HP마을귀환사용제한", "MP마을귀환사용제한", "리메듐사용제한", "마나포션사용제한", "브렐사용제한", "식빵사용제한", "MP마을귀환사용여부", "넣을아이템","Multiplyer","NPC_MSG_ADR" ,"마지막사냥장소", "수련용길탐색딜레이" ]
Global RadioButton := ["일무기", "일벗무바", "이무기", "이벗무바", "삼무기", "삼벗무바" ,"퍼펙트","일반","미스"]
Global CommonSkillList := ["대화","명상"]
Global NormalSkillList := ["더블어택","체력향상","민첩향상","활방어","마력향상","마법방어향상","집중","회피"]
Global TargetSkillList := ["훔치기","훔쳐보기","Sense","현혹","폭검","독침","무기공격"]
Global 특수원거리타겟OID := 0x0
loop, 10
{
	temp := A_Index
	temp .= "번캐릭터사용여부"
	EditList.push(temp)
	temp := A_Index
	temp .= "번캐릭터명"
	EditList.push(temp)
}
Global NeedRepair := 0
Global 마을귀환성공여부 := True
Global 일랜시아점검필요 := False
Global 몬스터리스트선택 := 0
Global 좌표X
Global 좌표Y
Global 좌표Z
Global 현재HP
Global 최대HP
Global 현재MP
Global 최대MP
Global 현재FP
Global 최대FP
Global 좀비몹 := False
Global StartTime := A_TickCount
Global 좌표구하기딜레이 := A_TickCount
Global StartCount := A_TickCount
Global 공격딜레이 := A_TickCount
Global 소지아이템리스트업데이트딜레이 := A_TickCount
Global RunThreadCounter := A_TickCount
Global PT_Delays := A_TickCount
Global Sam_Before := A_TickCount
Global NSK_Counts := A_TickCount
Global Item_Delays := A_TickCount

pixelsize := 20
greenimage := "green.png"
redimage := "red.png"
blackimage := "black.png"
pinkimage := "pink.png"
IsGuiExist := []
Global Multiplyer := "없음"
Global NPC_MSG_ADR := "없음"
Global 상승어빌주소
Global 합칠아이템순서
Global 행깃교환Coin := 0
GLobal 원거리루프 := 1
Global STOPSIGN := FALSE
Global 마지막사냥장소

게임내고용상인들 := ["소야","터그","네시","미피엘","엘가노","휘리스"]
게임내NPC들 := ["대장로","성향안내","장로","모험가","초보모험가","요리사","초보요리사","사냥꾼","초보무도가","세크티","콥","미너터","카리스","행운장","길드기","길드예선전보로1","길드예선전보로2","길드예선전보로3","길드예선전보로4","길드예선전보로5","길드예선전보로6","길드예선전보로7","길드예선전보로8","우물지기","우물지킴이","파미","실루엣","케이","휴","에레노아","길드만들기","라드","예절보로","할아버지","레나","초브","칼라스","브라키의여전사","테레즈","루비","오크왕자","슈","카딜라","나무보로","이사크","미소니","성궁사","수련장","그레파","미용바니","티포네","홀리","올드스미스","테디","피니","큐트","키드니","스텔라","실비아","네루아","사라","오블로","메티니","무타이","성검사","커스피스","쿠니퍼","라체","지올라","플린","헬러","브레너","에드가","두갈","아이렌","케드마","제프","젠","소니아","아바","네시아","래리","마리오","빈","렉스","다바트","코바니","플라노","미너스","토리온","브로이","카멘","카로에","시상보로","견습미용사","하즈","할머니","미스토","브라키의여전사","그라치","드리트","레시트","로크","메크","스타시","스테티나","이스카","호디니","베니","은행가드","파이","샤네트","코페","길드기","아일리아","퀘이드","레야","싱","유키오","이시","앨리아","오바","테론","윌라","페툴라","스티븐","우리안","빅터","리프","미네티","피트","비엔","길드기","칸느","포럼","콘스티","다인","티셔","백작","보초병","우트","랜스","뮤즈","리어","리즈","브라키의여전사","에스피","이트","코니","스투","라니체","드류","체드","체스터","케인","울드","티모시","포츠","마카","미카","경비병","니키","수라","카르고","엘피","쿠퍼","페니","터크","베이","나크레토","로비어","앤타이","길드기","셀포이","비바","마데이아","가토고","엑소포","토이슨","코메이오","저주받은엘프","야노모이","오이피노","카레푸","엠토포","아이보","마나오","클레오","파노아","타키아","카오네자","나노아","미노스","세니코","주사위소녀1","주사위소녀1","주사위소녀2","주사위소녀3","주사위소녀4","주사위소녀5","주사위소녀6","주사위소녀7","주사위소녀8","주사위소녀9","주사위소녀10","주사위","주사위지배인","리노스","투페","히포프","베스","쿠키","소피","포프리아","나무꾼","레아","키아","세르니오","코르티","베커","포비","크로리스","길잃은수색대","동쪽파수꾼","서쪽파수꾼","리노아","펫조련사"]
게임내쓸때없는존재들 := ["음악당","도서관","마법상점","잡화상점","무기상점","펍","우체국","대장간","은행","보석상점","교환장","병원","석공소","수련장소","여관","편집국","피니의옷가게","갑옷상점","베이커리","고깃상점","목공소"]
이름이바뀌는존재들 := [21,751,753]
;이름바꿔지는존재들
;수련인형(일랜기본) = 21
;클로버 751
;팬덕 753
;조심해야할것들
;수련인형(빨간색) = 27


메인캐릭터서버_DDLOptions := ["엘","테스"]
메인캐릭터순서_DDLOptions := [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20]
힐링포션사용단축키_DDLOptions := [5,6,7,8]
마나포션사용단축키_DDLOptions := [5,6,7,8]
식빵사용단축키_DDLOptions := [8,9]
오란의깃사용단축키_DDLOptions := [5,6,7,8]
식빵구매마을_DDLOptions := ["로랜시아","에필로리아","세르니카","크로노시스","포프레스네"]
핵심지침서_DDLOptions := ["목공지침서 1-1 소나무 가공(Lv1)", "목공지침서 1-2 단풍나무 가공(Lv1)", "목공지침서 1-3 참나무 가공(Lv1)","세공지침서 1-1 기초 세공(Lv1)","세공지침서 2-4 브라키디온 가공(Lv2)","세공지침서 3-4 알티브라키디온 가공(Lv3)","세공지침서 4-4 브라키시온(원석) 가공(Lv4)","세공지침서 5-4 브라키시온 가공(Lv5)","세공지침서 6-1 아이언링 제작1(Lv6)","세공지침서 7-1 아이언네클리스 제작1(Lv7)","세공지침서 8-3 케이온 제작(Lv8)","세공지침서 9-1 초급 가공1(Lv9)", "세공지침서 10-1 중급 가공1(Lv10)"]
지침서_DDLOptions := ["요리지침서 1-1 달걀 요리(Lv1)", "요리지침서 1-2 식빵 요리(Lv1)", "요리지침서 1-3 스프 요리(Lv1)", "요리지침서 1-4 샌드위치 요리(Lv1)", "요리지침서 1-5 초컬릿(Lv1)", "요리지침서 1-6 송편(Lv1)", "요리지침서 2-1 주먹밥 요리(Lv2)", "요리지침서 2-2 오믈렛 요리(Lv2)", "요리지침서 2-3 파이 요리(Lv2)", "요리지침서 2-4 케익 요리(Lv2)", "요리지침서 2-5 쥬스 요리(Lv2)", "요리지침서 3-1 카레 요리(Lv3)", "요리지침서 3-2 마늘 요리(Lv3)", "요리지침서 4-1 비스킷 요리(Lv4)", "요리지침서 4-2 닭고기 요리(Lv4)", "요리지침서 4-3 돼지고기 요리(Lv4)", "요리지침서 4-4 생선 요리(Lv4)", "요리지침서 4-5 초밥 요리(Lv4)", "요리지침서 5-1 팥빙수 요리(Lv5)", "요리지침서 5-2 스파게티 요리(Lv5)", "요리지침서 5-3 김치 요리(Lv5)", "요리지침서 5-4 볶음밥 요리(Lv5)", "스미스지침서 1-1 툴 수리(Lv1)", "스미스지침서 1-2 검 수리(Lv1)", "스미스지침서 1-3 창 수리(Lv1)", "스미스지침서 1-4 기타 수리(Lv1)", "스미스지침서 2-1 낚시대 제작(Lv2)", "스미스지침서 2-2 픽액스 제작(Lv2)", "스미스지침서 2-3 요리키트 제작(Lv2)", "스미스지침서 2-4 미리온스캐너 제작(Lv2)", "스미스지침서 2-5 스미스키트 제작(Lv2)", "스미스지침서 2-6 재단키트 제작(Lv2)", "스미스지침서 2-7 세공키트 제작(Lv2)", "스미스지침서 2-8 관측키트 제작(Lv2)", "스미스지침서 3-1 롱소드 제작(Lv3)", "스미스지침서 3-2 바스타드소드 제작(Lv3)", "스미스지침서 3-3 그레이트소드 제작(Lv3)", "스미스지침서 3-4 대거 제작(Lv3)", "스미스지침서 3-5 고태도 제작(Lv3)", "스미스지침서 3-6 롱스피어 제작(Lv3)", "스미스지침서 3-7 반월도 제작(Lv3)", "스미스지침서 3-8 액스 제작(Lv3)", "스미스지침서 3-9 햄머 제작(Lv3)", "스미스지침서 3-10 우든보우 제작(Lv3)", "스미스지침서 3-11 우든하프 제작(Lv3)", "스미스지침서 3-12 시미터 제작(Lv3)", "스미스지침서 4-1 아이언아머 제작(Lv4)", "스미스지침서 4-2 폴드아머 제작(Lv4)", "스미스지침서 4-3 스탠다드 아머 제작(Lv4)", "스미스지침서 4-4 터틀아머 제작(Lv4)", "스미스지침서 4-5 트로져아머 제작(Lv4)", "스미스지침서 4-6 숄드레더 아머 제작(Lv4)", "스미스지침서 4-7 밴디드레더 아머 제작(Lv4)", "스미스지침서 4-8 밴디드아이언 아머 제작(Lv4)", "스미스지침서 4-9 밴디드실버 아머 제작(Lv4)", "스미스지침서 4-10 밴디드골드 아머 제작(Lv4)", "스미스지침서 5-1 우든실드 제작(Lv5)", "스미스지침서 5-2 실드 제작(Lv5)", "스미스지침서 5-3 아이언실드 제작(Lv5)", "스미스지침서 5-4 스톤실드 제작(Lv5)", "스미스지침서 5-5 골든실드 제작(Lv5)", "스미스지침서 6-1 올드헬멧 제작(Lv6)", "재단지침서 1-1 반바지 수선(Lv1)", "재단지침서 1-2 바지 수선(Lv1)", "재단지침서 1-3 튜닉 수선(Lv1)", "재단지침서 1-4 가니쉬 수선(Lv1)", "재단지침서 1-5 레더슈즈 수선(Lv1)", "재단지침서 1-6 레더아머 수선(Lv1)", "재단지침서 2-1 반바지 제작(Lv2)", "재단지침서 2-2 바지 제작(Lv2)", "재단지침서 2-3 튜닉 제작(Lv2)", "재단지침서 2-4 가니쉬 제작(Lv2)", "재단지침서 2-5 레더슈즈 제작(Lv2)", "재단지침서 2-6 레더아머 제작(Lv2)", "재단지침서 2-7 수영모 제작(Lv2)", "재단지침서 2-8 꽃무늬수영모 제작(Lv2)", "재단지침서 3-1 울슈즈 제작(Lv3)", "재단지침서 3-2 밤슈즈 제작(Lv3)", "재단지침서 4-1 밧줄 제작(Lv4)", "재단지침서 4-2 꽃무늬반바지 제작(Lv4)", "재단지침서 4-3 꽃무늬바지 제작(Lv4)", "재단지침서 4-4 꽃무늬치마 제작(Lv4)", "재단지침서 4-5 줄무늬바지 제작(Lv4)", "재단지침서 4-6 나팔바지 제작(Lv4)", "재단지침서 4-7 칠부바지 제작(Lv4)", "재단지침서 4-8 꽃무늬튜닉 제작(Lv4)", "재단지침서 4-9 줄무늬튜닉 제작(Lv4)", "재단지침서 4-10 터번 제작(Lv4)", "재단지침서 4-11 볼륨업브라 제작(Lv4)", "재단지침서 4-12 탑 제작(Lv4)", "재단지침서 4-13 미니스커트 제작(Lv4)", "재단지침서 4-14 햅번민소매 제작(Lv4)", "재단지침서 4-15 햅번긴소매 제작(Lv4)", "재단지침서 4-16 땡땡브라 제작(Lv4)", "재단지침서 4-17 니혼모자 제작(Lv4)", "재단지침서 5-1 튜닉 제작2(Lv5)", "재단지침서 5-2 반바지 제작2(Lv5)", "재단지침서 5-3 바지 제작2(Lv5)", "재단지침서 5-4 가니쉬 제작2(Lv5)", "재단지침서 5-5 레더아머 제작2(Lv5)", "재단지침서 5-6 레더슈즈 제작2(Lv5)", "재단지침서 5-7 울슈즈 제작2(Lv5)", "재단지침서 5-8 밤슈즈 제작2(Lv5)", "재단지침서 5-9 수영모 제작2(Lv5)", "재단지침서 5-10 꽃무늬수영모 제작2(Lv5)", "세공지침서 1-1 기초 세공(Lv1)", "세공지침서 1-2 링 수리(Lv1)", "세공지침서 1-3 네클리스 수리(Lv1)", "세공지침서 2-1 브리디온 가공(Lv2)", "세공지침서 2-2 다니온 가공(Lv2)", "세공지침서 2-3 마하디온 가공(Lv2)", "세공지침서 2-4 브라키디온 가공(Lv2)", "세공지침서 2-5 브라키디온 가공(Lv2)", "세공지침서 2-6 테사랏티온 가공(Lv2)", "세공지침서 3-1 알티브리디온 가공(Lv3)", "세공지침서 3-2 알티다니온 가공(Lv3)", "세공지침서 3-3 알티마하디온 가공(Lv3)", "세공지침서 3-4 알티브라키디온 가공(Lv3)", "세공지침서 3-5 볼바디온 가공(Lv3)", "세공지침서 3-6 테사리온 가공(Lv3)", "세공지침서 4-1 브리시온(원석) 가공(Lv4)", "세공지침서 4-2 다니시온(원석) 가공(Lv4)", "세공지침서 4-3 마흐시온(원석) 가공(Lv4)", "세공지침서 4-4 브라키시온(원석) 가공(Lv4)", "세공지침서 4-5 엘리시온(원석) 가공(Lv4)", "세공지침서 4-6 테스시온(원석) 가공(Lv4)", "세공지침서 5-1 브리시온 가공(Lv5)", "세공지침서 5-2 다니시온 가공(Lv5)", "세공지침서 5-3 마흐시온 가공(Lv5)", "세공지침서 5-4 브라키시온 가공(Lv5)", "세공지침서 5-5 엘리시온 가공(Lv5)", "세공지침서 5-6 테스시온 가공(Lv5)", "세공지침서 6-1 아이언링 제작1(Lv6)", "세공지침서 6-2 실버링 제작1(Lv6)", "세공지침서 6-3 골드링 제작1(Lv6)", "세공지침서 6-4 에메랄드링 제작1(Lv6)", "세공지침서 6-5 사파이어링 제작1(Lv6)", "세공지침서 6-6 투어마린링 제작1(Lv6)", "세공지침서 6-7 브리디온링 제작1(Lv6)", "세공지침서 6-8 다니온링 제작1(Lv6)", "세공지침서 6-9 마하디온링 제작1(Lv6)", "세공지침서 6-10 브라키디온링 제작1(Lv6)", "세공지침서 6-11 엘사리온링 제작1(Lv6)", "세공지침서 6-12 테사리온링 제작1(Lv6)", "세공지침서 7-1 아이언네클리스 제작1(Lv7)", "세공지침서 7-2 실버네클리스 제작1(Lv7)", "세공지침서 7-3 골드네클리스 제작1(Lv7)", "세공지침서 7-4 루비네클리스 제작1(Lv7)", "세공지침서 7-5 상아네클리스 제작1(Lv7)", "세공지침서 7-6 사파이어네클리스 제작1(Lv7)", "세공지침서 7-7 펄네클리스 제작1(Lv7)", "세공지침서 7-8 블랙펄네클리스 제작1(Lv7)", "세공지침서 7-9 오레온 제작(Lv7)", "세공지침서 7-10 세레온 제작(Lv7)", "세공지침서 8-1 기초 가공1(Lv8)", "세공지침서 8-2 기초 가공2(Lv8)", "세공지침서 8-3 케이온 제작(Lv8)", "세공지침서 9-1 초급 가공1(Lv9)", "세공지침서 10-1 중급 가공1(Lv10)", "세공지침서 11-1 고급 가공1(Lv11)", "미용지침서 1-1 기초 염색(Lv1)", "미용지침서 2-1 삭발 스타일(Lv2)", "미용지침서 2-2 기본 스타일(Lv2)", "미용지침서 2-3 펑크 스타일(Lv2)", "미용지침서 2-4 레게 스타일(Lv2)", "미용지침서 2-5 변형 스타일(Lv2)", "미용지침서 2-6 더벅 스타일(Lv2)", "미용지침서 2-7 바람 스타일(Lv2)", "미용지침서 2-8 복고 스타일(Lv2)", "미용지침서 2-9 자연 스타일(Lv2)", "미용지침서 2-10 웨이브 스타일(Lv2)", "미용지침서 2-11 세팅 스타일(Lv2)", "미용지침서 2-12 폭탄 스타일(Lv2)", "미용지침서 2-13 야자수 스타일(Lv2)", "미용지침서 2-14 발랄 스타일(Lv2)", "미용지침서 2-15 변형레게 스타일(Lv2)", "미용지침서 2-16 올림 스타일(Lv2)", "미용지침서 2-17 곱슬 스타일(Lv2)", "미용지침서 2-18 미남스타일 변형(Lv2)", "미용지침서 2-19 바가지 스타일(Lv2)", "미용지침서 2-20 선녀 스타일(Lv2)", "미용지침서 2-21 밤톨 스타일(Lv2)", "미용지침서 2-22 귀족 스타일(Lv2)", "미용지침서 2-23 드라마 스타일(Lv2)", "미용지침서 2-24 앙증 스타일(Lv2)", "미용지침서 2-25 트윈테일 스타일(Lv2)", "미용지침서 3-1 검은눈 성형(Lv3)", "미용지침서 3-2 파란눈 성형(Lv3)", "미용지침서 3-3 찢어진눈 성형(Lv3)", "목공지침서 1-1 소나무 가공(Lv1)", "목공지침서 1-2 단풍나무 가공(Lv1)", "목공지침서 1-3 참나무 가공(Lv1)", "목공지침서 1-4 대나무 가공(Lv1)", "목공지침서 2-1 토끼조각상 조각(Lv2)", "목공지침서 2-2 암탉조각상 조각(Lv2)", "목공지침서 2-3 수탉조각상 조각(Lv2)", "목공지침서 2-4 푸푸조각상 조각(Lv2)", "목공지침서 3-1 토끼상자 조각(Lv3)", "목공지침서 3-2 푸푸상자 조각(Lv3)", "목공지침서 3-3 오크상자 조각(Lv3)", "목공지침서 3-4 고블린상자 조각(Lv3)", "목공지침서 4-1 뗏목 제작(Lv4)", "목공지침서 4-2 나무보트 제작(Lv4)", "목공지침서 5-1 스노우보드 제작(Lv5)", "목공지침서 5-2 썰매 제작(Lv5)", "연금술지침서 1-1 힐링포션 제작(Lv1)", "연금술지침서 1-2 마나포션 제작(Lv1)", "연금술지침서 1-3 단검용독 제작(Lv1)", "연금술지침서 2-1 스피드포션(1ml) 제작(Lv2)", "연금술지침서 2-2 스피드포션(2ml) 제작(Lv2)", "연금술지침서 2-3 스피드포션(3ml) 제작(Lv2)", "연금술지침서 2-4 스피드포션(4ml) 제작(Lv2)", "연금술지침서 2-5 스피드포션(5ml) 제작(Lv2)", "연금술지침서 2-6 스피드포션(6ml) 제작(Lv2)", "연금술지침서 2-7 체력향상포션(1ml) 제작(Lv2)", "연금술지침서 2-8 체력향상포션(2ml) 제작(Lv2)", "연금술지침서 2-9 체력향상포션(3ml) 제작(Lv2)", "연금술지침서 2-10 체력향상포션(4ml) 제작(Lv2)", "연금술지침서 2-11 체력향상포션(5ml) 제작(Lv2)", "연금술지침서 2-12 체력향상포션(6ml) 제작(Lv2)", "연금술지침서 3-1 주괴 제작(Lv3)"]

Global CoordDataFile := "CoordData.txt"
GLobal dlm:=";"
Global Coin
Global mem
Global ElanTitles
Global TargetPid
Global Moving_check
Global TargetTitle := ""
Global 광물캐기루프_TimerRunning := False
Global 다음좌표 := 1
Global Multiplyer = "없음"
Global 줍줍 := False
Read_Elancia_Titles()
Global isFirstTimeRunThisCode := 1
Setworkingdir,%a_scriptdir%
Global 성공실패주소 := 0
Global MonsterList := []
Global itemList := []
Global PlayerList := []
Global BlackList := []
Global deletedelay := 1
Global CHECKED맵번호 := 0
Global 오란의깃갯수 := 0
Global 라스의깃갯수 := 0
Global 정령의보석갯수 := 0
Global 식빵갯수 := 0
Global 특별한오란의깃갯수 := 0
Global 행운이깃든종이갯수 := 0
Global 생명의콩갯수 := 0
Global 리메듐갯수 := 0
Global 브리스갯수 := 0
Global 작은얼음조각갯수 := 0
Global 유익인의날개갯수 := 0
Global 조개갯수 := 0
Global 약초갯수 := 0
Global 사슴고기갯수 := 0
Global 빛나는가루갯수 := 0
Global 빛나는나뭇가지갯수 := 0
Global 빛나는결정갯수 := 0
Global WaaponLimit
Global UsePunch
Global 무기_Coin
Global hit1 := mem.read(0x0058dad4,"UINT",0x1a5)
Global WeaponNumber := 1
Global 식빵사용카운트 := 0
gosub, ShowGui
return


;-------------------------------------------------------
;-------외부 함수----------------------------------------
;-------------------------------------------------------
class _ClassMemory
{
static baseAddress, hProcess, PID, currentProgram
, insertNullTerminator := True
, readStringLastError := False
, isTarget64bit := False
, ptrType := "UInt"
, aTypeSize := {    "UChar":    1,  "Char":     1
,   "UShort":   2,  "Short":    2
,   "UInt":     4,  "Int":      4
,   "UFloat":   4,  "Float":    4
,   "Int64":    8,  "Double":   8}
, aRights := {  "PROCESS_ALL_ACCESS": 0x001F0FFF
,   "PROCESS_CREATE_PROCESS": 0x0080
,   "PROCESS_CREATE_THREAD": 0x0002
,   "PROCESS_DUP_HANDLE": 0x0040
,   "PROCESS_QUERY_INFORMATION": 0x0400
,   "PROCESS_QUERY_LIMITED_INFORMATION": 0x1000
,   "PROCESS_SET_INFORMATION": 0x0200
,   "PROCESS_SET_QUOTA": 0x0100
,   "PROCESS_SUSPEND_RESUME": 0x0800
,   "PROCESS_TERMINATE": 0x0001
,   "PROCESS_VM_OPERATION": 0x0008
,   "PROCESS_VM_READ": 0x0010
,   "PROCESS_VM_WRITE": 0x0020
,   "SYNCHRONIZE": 0x00100000}

__new(program, dwDesiredAccess := "", byRef handle := "", windowMatchMode := 3)
{
if this.PID := handle := this.findPID(program, windowMatchMode) ; set handle to 0 if program not found
{
if dwDesiredAccess is not integer
dwDesiredAccess := this.aRights.PROCESS_QUERY_INFORMATION | this.aRights.PROCESS_VM_OPERATION | this.aRights.PROCESS_VM_READ | this.aRights.PROCESS_VM_WRITE
dwDesiredAccess |= this.aRights.SYNCHRONIZE ; add SYNCHRONIZE to all handles to allow isHandleValid() to work
if this.hProcess := handle := this.OpenProcess(this.PID, dwDesiredAccess) ; NULL/Blank if failed to open process for some reason
{
this.pNumberOfBytesRead := DllCall("GlobalAlloc", "UInt", 0x0040, "Ptr", A_PtrSize, "Ptr") ; 0x0040 initialise to 0
this.pNumberOfBytesWritten := DllCall("GlobalAlloc", "UInt", 0x0040, "Ptr", A_PtrSize, "Ptr") ; initialise to 0

this.readStringLastError := False
this.currentProgram := program
if this.isTarget64bit := this.isTargetProcess64Bit(this.PID, this.hProcess, dwDesiredAccess)
this.ptrType := "Int64"
else this.ptrType := "UInt" ; If false or Null (fails) assume 32bit

if (A_PtrSize != 4 || !this.isTarget64bit)
this.BaseAddress := this.getModuleBaseAddress()

if this.BaseAddress < 0 || !this.BaseAddress
this.BaseAddress := this.getProcessBaseAddress(program, windowMatchMode)

return this
}
}
return
}

__delete()
{
this.closeHandle(this.hProcess)
if this.pNumberOfBytesRead
DllCall("GlobalFree", "Ptr", this.pNumberOfBytesRead)
if this.pNumberOfBytesWritten
DllCall("GlobalFree", "Ptr", this.pNumberOfBytesWritten)
return
}

version()
{
return 2.92
}

findPID(program, windowMatchMode := "3")
{
if RegExMatch(program, "i)\s*AHK_PID\s+(0x[[:xdigit:]]+|\d+)", pid)
return pid1
if windowMatchMode
{
mode := A_TitleMatchMode
StringReplace, windowMatchMode, windowMatchMode, 0x
SetTitleMatchMode, %windowMatchMode%
}
WinGet, pid, pid, ahk_pid %pid%
if windowMatchMode
SetTitleMatchMode, %mode%

if (!pid && RegExMatch(program, "i)\bAHK_EXE\b\s*(.*)", fileName))
{
filename := RegExReplace(filename1, "i)\bahk_(class|id|pid|group)\b.*", "")
filename := trim(filename)    ; extra spaces will make process command fail
SplitPath, fileName , fileName
if (fileName) ; if filename blank, scripts own pid is returned
{
process, Exist, %fileName%
pid := ErrorLevel
}
}
return pid ? pid : 0 ; PID is null on fail, return 0
}

isHandleValid()
{
return 0x102 = DllCall("WaitForSingleObject", "Ptr", this.hProcess, "UInt", 0)
}

openProcess(PID, dwDesiredAccess)
{
r := DllCall("OpenProcess", "UInt", dwDesiredAccess, "Int", False, "UInt", PID, "Ptr")
if (!r && A_LastError = 5)
{
this.setSeDebugPrivilege(true) ; no harm in enabling it if it is already enabled by user
if (r2 := DllCall("OpenProcess", "UInt", dwDesiredAccess, "Int", False, "UInt", PID, "Ptr"))
return r2
DllCall("SetLastError", "UInt", 5) ; restore original error if it doesnt work
}
return r ? r : ""
}

closeHandle(hProcess)
{
return DllCall("CloseHandle", "Ptr", hProcess)
}

numberOfBytesRead()
{
return !this.pNumberOfBytesRead ? -1 : NumGet(this.pNumberOfBytesRead+0, "Ptr")
}
numberOfBytesWritten()
{
return !this.pNumberOfBytesWritten ? -1 : NumGet(this.pNumberOfBytesWritten+0, "Ptr")
}

read(address, type := "UInt", aOffsets*)
{
if !this.aTypeSize.hasKey(type)
return "", ErrorLevel := -2
if DllCall("ReadProcessMemory", "Ptr", this.hProcess, "Ptr", aOffsets.maxIndex() ? this.getAddressFromOffsets(address, aOffsets*) : address, type "*", result, "Ptr", this.aTypeSize[type], "Ptr", this.pNumberOfBytesRead)
return result
return
}

readRaw(address, byRef buffer, bytes := 4, aOffsets*)
{
VarSetCapacity(buffer, bytes)
return DllCall("ReadProcessMemory", "Ptr", this.hProcess, "Ptr", aOffsets.maxIndex() ? this.getAddressFromOffsets(address, aOffsets*) : address, "Ptr", &buffer, "Ptr", bytes, "Ptr", this.pNumberOfBytesRead)
}

readString(address, sizeBytes := 0, encoding := "UTF-8", aOffsets*)
{
bufferSize := VarSetCapacity(buffer, sizeBytes ? sizeBytes : 100, 0)
this.ReadStringLastError := False
if aOffsets.maxIndex()
address := this.getAddressFromOffsets(address, aOffsets*)
if !sizeBytes  ; read until null terminator is found or something goes wrong
{
if (encoding = "utf-16" || encoding = "cp1200")
encodingSize := 2, charType := "UShort", loopCount := 2
else encodingSize := 1, charType := "Char", loopCount := 4
Loop
{   ; Lets save a few reads by reading in 4 byte chunks
if !DllCall("ReadProcessMemory", "Ptr", this.hProcess, "Ptr", address + ((outterIndex := A_index) - 1) * 4, "Ptr", &buffer, "Ptr", 4, "Ptr", this.pNumberOfBytesRead) || ErrorLevel
return "", this.ReadStringLastError := True
else loop, %loopCount%
{
if NumGet(buffer, (A_Index - 1) * encodingSize, charType) = 0 ; NULL terminator
{
if (bufferSize < sizeBytes := outterIndex * 4 - (4 - A_Index * encodingSize))
VarSetCapacity(buffer, sizeBytes)
break, 2
}
}
}
}
if DllCall("ReadProcessMemory", "Ptr", this.hProcess, "Ptr", address, "Ptr", &buffer, "Ptr", sizeBytes, "Ptr", this.pNumberOfBytesRead)
return StrGet(&buffer,, encoding)
return "", this.ReadStringLastError := True
}

executable(address, RegionSize) {
PAGE_EXECUTE_READWRITE := 0x40 ; Define constants for memory protection
DllCall("VirtualProtectEx", "Ptr", this.hProcess, "Ptr", address, "Ptr", RegionSize, "Ptr", PAGE_EXECUTE_READWRITE, "Ptr*", oldProtection) ; Call VirtualProtectEx to change the memory protection
}

write7bytes(address, value) {
return DllCall("WriteProcessMemory", "UInt", this.hProcess, "UInt", address, "Uint*", value, "Uint", 07, "Uint*", 0)
}

writeString(address, string, encoding := "utf-8", aOffsets*)
{
encodingSize := (encoding = "utf-16" || encoding = "cp1200") ? 2 : 1
requiredSize := StrPut(string, encoding) * encodingSize - (this.insertNullTerminator ? 0 : encodingSize)
VarSetCapacity(buffer, requiredSize)
StrPut(string, &buffer, StrLen(string) + (this.insertNullTerminator ?  1 : 0), encoding)
return DllCall("WriteProcessMemory", "Ptr", this.hProcess, "Ptr", aOffsets.maxIndex() ? this.getAddressFromOffsets(address, aOffsets*) : address, "Ptr", &buffer, "Ptr", requiredSize, "Ptr", this.pNumberOfBytesWritten)
}

write(address, value, type := "Uint", aOffsets*)
{
if !this.aTypeSize.hasKey(type)
return "", ErrorLevel := -2
return DllCall("WriteProcessMemory", "Ptr", this.hProcess, "Ptr", aOffsets.maxIndex() ? this.getAddressFromOffsets(address, aOffsets*) : address, type "*", value, "Ptr", this.aTypeSize[type], "Ptr", this.pNumberOfBytesWritten)
}

writeRaw(address, pBuffer, sizeBytes, aOffsets*)
{
return DllCall("WriteProcessMemory", "Ptr", this.hProcess, "Ptr", aOffsets.maxIndex() ? this.getAddressFromOffsets(address, aOffsets*) : address, "Ptr", pBuffer, "Ptr", sizeBytes, "Ptr", this.pNumberOfBytesWritten)
}

writeBytes(address, hexStringOrByteArray, aOffsets*)
{
if !IsObject(hexStringOrByteArray)
{
if !IsObject(hexStringOrByteArray := this.hexStringToPattern(hexStringOrByteArray))
return hexStringOrByteArray
}
sizeBytes := this.getNeedleFromAOBPattern("", buffer, hexStringOrByteArray*)
return this.writeRaw(address, &buffer, sizeBytes, aOffsets*)
}

pointer(address, finalType := "UInt", offsets*)
{
For index, offset in offsets
address := this.Read(address, this.ptrType) + offset
Return this.Read(address, finalType)
}

getAddressFromOffsets(address, aOffsets*)
{
return  aOffsets.Remove() + this.pointer(address, this.ptrType, aOffsets*) ; remove the highest key so can use pointer() to find final memory address (minus the last offset)
}

getProcessBaseAddress(windowTitle, windowMatchMode := "3")
{
if (windowMatchMode && A_TitleMatchMode != windowMatchMode)
{
mode := A_TitleMatchMode ; This is a string and will not contain the 0x prefix
StringReplace, windowMatchMode, windowMatchMode, 0x ; remove hex prefix as SetTitleMatchMode will throw a run time error. This will occur if integer mode is set to hex and matchmode param is passed as an number not a string.
SetTitleMatchMode, %windowMatchMode%    ;mode 3 is an exact match
}
WinGet, hWnd, ID, ahk_pid %pid%
if mode
SetTitleMatchMode, %mode%    ; In case executed in autoexec
if !hWnd
return ; return blank failed to find window
return DllCall(A_PtrSize = 4     ; If DLL call fails, returned value will = 0
? "GetWindowLong"
: "GetWindowLongPtr"
, "Ptr", hWnd, "Int", -6, A_Is64bitOS ? "Int64" : "UInt")
}

getModuleBaseAddress(moduleName := "", byRef aModuleInfo := "")
{
aModuleInfo := ""
if (moduleName = "")
moduleName := this.GetModuleFileNameEx(0, True) ; main executable module of the process - get just fileName no path
if r := this.getModules(aModules, True) < 0
return r ; -4, -3
return aModules.HasKey(moduleName) ? (aModules[moduleName].lpBaseOfDll, aModuleInfo := aModules[moduleName]) : -1
}

getModuleFromAddress(address, byRef aModuleInfo, byRef offsetFromModuleBase := "")
{
aModuleInfo := offsetFromModule := ""
if result := this.getmodules(aModules) < 0
return result ; error -3, -4
for k, module in aModules
{
if (address >= module.lpBaseOfDll && address < module.lpBaseOfDll + module.SizeOfImage)
return 1, aModuleInfo := module, offsetFromModuleBase := address - module.lpBaseOfDll
}
return -1
}

setSeDebugPrivilege(enable := True)
{
h := DllCall("OpenProcess", "UInt", 0x0400, "Int", false, "UInt", DllCall("GetCurrentProcessId"), "Ptr")
DllCall("Advapi32.dll\OpenProcessToken", "Ptr", h, "UInt", 32, "PtrP", t)
VarSetCapacity(ti, 16, 0)  ; structure of privileges
NumPut(1, ti, 0, "UInt")  ; one entry in the privileges array...
DllCall("Advapi32.dll\LookupPrivilegeValue", "Ptr", 0, "Str", "SeDebugPrivilege", "Int64P", luid)
NumPut(luid, ti, 4, "Int64")
if enable
NumPut(2, ti, 12, "UInt")  ; enable this privilege: SE_PRIVILEGE_ENABLED = 2
r := DllCall("Advapi32.dll\AdjustTokenPrivileges", "Ptr", t, "Int", false, "Ptr", &ti, "UInt", 0, "Ptr", 0, "Ptr", 0)
DllCall("CloseHandle", "Ptr", t)  ; close this access token handle to save memory
DllCall("CloseHandle", "Ptr", h)  ; close this process handle to save memory
return r
}

isTargetProcess64Bit(PID, hProcess := "", currentHandleAccess := "")
{
if !A_Is64bitOS
return False
; If insufficient rights, open a temporary handle
else if !hProcess || !(currentHandleAccess & (this.aRights.PROCESS_QUERY_INFORMATION | this.aRights.PROCESS_QUERY_LIMITED_INFORMATION))
closeHandle := hProcess := this.openProcess(PID, this.aRights.PROCESS_QUERY_INFORMATION)
if (hProcess && DllCall("IsWow64Process", "Ptr", hProcess, "Int*", Wow64Process))
result := !Wow64Process
return result, closeHandle ? this.CloseHandle(hProcess) : ""
}

suspend()
{
return DllCall("ntdll\NtSuspendProcess", "Ptr", this.hProcess)
}

resume()
{
return DllCall("ntdll\NtResumeProcess", "Ptr", this.hProcess)
}

getModules(byRef aModules, useFileNameAsKey := False)
{
if (A_PtrSize = 4 && this.IsTarget64bit)
return -4 ; AHK is 32bit and target process is 64 bit, this function wont work
aModules := []
if !moduleCount := this.EnumProcessModulesEx(lphModule)
return -3
loop % moduleCount
{
this.GetModuleInformation(hModule := numget(lphModule, (A_index - 1) * A_PtrSize), aModuleInfo)
aModuleInfo.Name := this.GetModuleFileNameEx(hModule)
filePath := aModuleInfo.name
SplitPath, filePath, fileName
aModuleInfo.fileName := fileName
if useFileNameAsKey
aModules[fileName] := aModuleInfo
else aModules.insert(aModuleInfo)
}
return moduleCount
}

getEndAddressOfLastModule(byRef aModuleInfo := "")
{
if !moduleCount := this.EnumProcessModulesEx(lphModule)
return -3
hModule := numget(lphModule, (moduleCount - 1) * A_PtrSize)
if this.GetModuleInformation(hModule, aModuleInfo)
return aModuleInfo.lpBaseOfDll + aModuleInfo.SizeOfImage
return -5
}

GetModuleFileNameEx(hModule := 0, fileNameNoPath := False)
{
VarSetCapacity(lpFilename, 2048 * (A_IsUnicode ? 2 : 1))
DllCall("psapi\GetModuleFileNameEx"
, "Ptr", this.hProcess
, "Ptr", hModule
, "Str", lpFilename
, "Uint", 2048 / (A_IsUnicode ? 2 : 1))
if fileNameNoPath
SplitPath, lpFilename, lpFilename ; strips the path so = GDI32.dll

return lpFilename
}

EnumProcessModulesEx(byRef lphModule, dwFilterFlag := 0x03)
{
lastError := A_LastError
size := VarSetCapacity(lphModule, 4)
loop
{
DllCall("psapi\EnumProcessModulesEx"
, "Ptr", this.hProcess
, "Ptr", &lphModule
, "Uint", size
, "Uint*", reqSize
, "Uint", dwFilterFlag)
if ErrorLevel
return 0
else if (size >= reqSize)
break
else size := VarSetCapacity(lphModule, reqSize)
}
DllCall("SetLastError", "UInt", lastError)
return reqSize // A_PtrSize ; module count  ; sizeof(HMODULE) - enumerate the array of HMODULEs
}

GetModuleInformation(hModule, byRef aModuleInfo)
{
VarSetCapacity(MODULEINFO, A_PtrSize * 3), aModuleInfo := []
return DllCall("psapi\GetModuleInformation"
, "Ptr", this.hProcess
, "Ptr", hModule
, "Ptr", &MODULEINFO
, "UInt", A_PtrSize * 3)
, aModuleInfo := {  lpBaseOfDll: numget(MODULEINFO, 0, "Ptr")
,   SizeOfImage: numget(MODULEINFO, A_PtrSize, "UInt")
,   EntryPoint: numget(MODULEINFO, A_PtrSize * 2, "Ptr") }
}

hexStringToPattern(hexString)
{
AOBPattern := []
hexString := RegExReplace(hexString, "(\s|0x)")
StringReplace, hexString, hexString, ?, ?, UseErrorLevel
wildCardCount := ErrorLevel

if !length := StrLen(hexString)
return -1 ; no str
else if RegExMatch(hexString, "[^0-9a-fA-F?]")
return -2 ; non hex character and not a wild card
else if Mod(wildCardCount, 2)
return -3 ; non-even wild card character count
else if Mod(length, 2)
return -4 ; non-even character count
loop, % length/2
{
value := "0x" SubStr(hexString, 1 + 2 * (A_index-1), 2)
AOBPattern.Insert(value + 0 = "" ? "?" : value)
}
return AOBPattern
}

stringToPattern(string, encoding := "UTF-8", insertNullTerminator := False)
{
if !length := StrLen(string)
return -1 ; no str
AOBPattern := []
encodingSize := (encoding = "utf-16" || encoding = "cp1200") ? 2 : 1
requiredSize := StrPut(string, encoding) * encodingSize - (insertNullTerminator ? 0 : encodingSize)
VarSetCapacity(buffer, requiredSize)
StrPut(string, &buffer, length + (insertNullTerminator ?  1 : 0), encoding)
loop, % requiredSize
AOBPattern.Insert(NumGet(buffer, A_Index-1, "UChar"))
return AOBPattern
}

modulePatternScan(module := "", aAOBPattern*)
{
MEM_COMMIT := 0x1000, MEM_MAPPED := 0x40000, MEM_PRIVATE := 0x20000
, PAGE_NOACCESS := 0x01, PAGE_GUARD := 0x100

if (result := this.getModuleBaseAddress(module, aModuleInfo)) <= 0
return "", ErrorLevel := result ; failed
if !patternSize := this.getNeedleFromAOBPattern(patternMask, AOBBuffer, aAOBPattern*)
return -10 ; no pattern
if (result := this.PatternScan(aModuleInfo.lpBaseOfDll, aModuleInfo.SizeOfImage, patternMask, AOBBuffer)) >= 0
return result  ; Found / not found
address := aModuleInfo.lpBaseOfDll
endAddress := address + aModuleInfo.SizeOfImage
loop
{
if !this.VirtualQueryEx(address, aRegion)
return -9
if (aRegion.State = MEM_COMMIT
&& !(aRegion.Protect & (PAGE_NOACCESS | PAGE_GUARD)) ; can't read these areas
&& aRegion.RegionSize >= patternSize
&& (result := this.PatternScan(address, aRegion.RegionSize, patternMask, AOBBuffer)) > 0)
return result
} until (address += aRegion.RegionSize) >= endAddress
return 0
}

addressPatternScan(startAddress, sizeOfRegionBytes, aAOBPattern*)
{
if !this.getNeedleFromAOBPattern(patternMask, AOBBuffer, aAOBPattern*)
return -10
return this.PatternScan(startAddress, sizeOfRegionBytes, patternMask, AOBBuffer)
}

processPatternScan(startAddress := "", endAddress := "", aAOBPattern*)
{
address := startAddress
if endAddress is not integer
endAddress := this.isTarget64bit ? (A_PtrSize = 8 ? 0x7FFFFFFFFFF : 0xFFFFFFFF) : 0x7FFFFFFF

MEM_COMMIT := 0x1000, MEM_MAPPED := 0x40000, MEM_PRIVATE := 0x20000
PAGE_NOACCESS := 0x01, PAGE_GUARD := 0x100
if !patternSize := this.getNeedleFromAOBPattern(patternMask, AOBBuffer, aAOBPattern*)
return -10
while address <= endAddress ; > 0x7FFFFFFF - definitely reached the end of the useful area (at least for a 32 target process)
{
if !this.VirtualQueryEx(address, aInfo)
return -1
if A_Index = 1
aInfo.RegionSize -= address - aInfo.BaseAddress
if (aInfo.State = MEM_COMMIT)
&& !(aInfo.Protect & (PAGE_NOACCESS | PAGE_GUARD)) ; can't read these areas
;&& (aInfo.Type = MEM_MAPPED || aInfo.Type = MEM_PRIVATE) ;Might as well read Image sections as well
&& aInfo.RegionSize >= patternSize
&& (result := this.PatternScan(address, aInfo.RegionSize, patternMask, AOBBuffer))
{
if result < 0
return -2
else if (result + patternSize - 1 <= endAddress)
return result
else return 0
}
address += aInfo.RegionSize
}
return 0
}

rawPatternScan(byRef buffer, sizeOfBufferBytes := "", startOffset := 0, aAOBPattern*)
{
if !this.getNeedleFromAOBPattern(patternMask, AOBBuffer, aAOBPattern*)
return -10
if (sizeOfBufferBytes + 0 = "" || sizeOfBufferBytes <= 0)
sizeOfBufferBytes := VarSetCapacity(buffer)
if (startOffset + 0 = "" || startOffset < 0)
startOffset := 0
return this.bufferScanForMaskedPattern(&buffer, sizeOfBufferBytes, patternMask, &AOBBuffer, startOffset)
}

getNeedleFromAOBPattern(byRef patternMask, byRef needleBuffer, aAOBPattern*)
{
patternMask := "", VarSetCapacity(needleBuffer, aAOBPattern.MaxIndex())
for i, v in aAOBPattern
patternMask .= (v + 0 = "" ? "?" : "x"), NumPut(round(v), needleBuffer, A_Index - 1, "UChar")
return round(aAOBPattern.MaxIndex())
}

VirtualQueryEx(address, byRef aInfo)
{

if (aInfo.__Class != "_ClassMemory._MEMORY_BASIC_INFORMATION")
aInfo := new this._MEMORY_BASIC_INFORMATION()
return aInfo.SizeOfStructure = DLLCall("VirtualQueryEx"
, "Ptr", this.hProcess
, "Ptr", address
, "Ptr", aInfo.pStructure
, "Ptr", aInfo.SizeOfStructure
, "Ptr")
}

patternScan(startAddress, sizeOfRegionBytes, byRef patternMask, byRef needleBuffer)
{
if !this.readRaw(startAddress, buffer, sizeOfRegionBytes)
return -1
if (offset := this.bufferScanForMaskedPattern(&buffer, sizeOfRegionBytes, patternMask, &needleBuffer)) >= 0
return startAddress + offset
else return 0
}

bufferScanForMaskedPattern(hayStackAddress, sizeOfHayStackBytes, byRef patternMask, needleAddress, startOffset := 0)
{
static p
if !p
{
if A_PtrSize = 4
p := this.MCode("1,x86:8B44240853558B6C24182BC5568B74242489442414573BF0773E8B7C241CBB010000008B4424242BF82BD8EB038D49008B54241403D68A0C073A0A740580383F750B8D0C033BCD74174240EBE98B442424463B74241876D85F5E5D83C8FF5BC35F8BC65E5D5BC3")
else
p := this.MCode("1,x64:48895C2408488974241048897C2418448B5424308BF2498BD8412BF1488BF9443BD6774A4C8B5C24280F1F800000000033C90F1F400066660F1F840000000000448BC18D4101418D4AFF03C80FB60C3941380C18740743803C183F7509413BC1741F8BC8EBDA41FFC2443BD676C283C8FF488B5C2408488B742410488B7C2418C3488B5C2408488B742410488B7C2418418BC2C3")
}
if (needleSize := StrLen(patternMask)) + startOffset > sizeOfHayStackBytes
return -1 ; needle can't exist inside this region. And basic check to prevent wrap around error of the UInts in the machine function
if (sizeOfHayStackBytes > 0)
return DllCall(p, "Ptr", hayStackAddress, "UInt", sizeOfHayStackBytes, "Ptr", needleAddress, "UInt", needleSize, "AStr", patternMask, "UInt", startOffset, "cdecl int")
return -2
}

MCode(mcode)
{
static e := {1:4, 2:1}, c := (A_PtrSize=8) ? "x64" : "x86"
if !regexmatch(mcode, "^([0-9]+),(" c ":|.*?," c ":)([^,]+)", m)
return
if !DllCall("crypt32\CryptStringToBinary", "str", m3, "uint", 0, "uint", e[m1], "ptr", 0, "uint*", s, "ptr", 0, "ptr", 0)
return
p := DllCall("GlobalAlloc", "uint", 0, "ptr", s, "ptr")
; if (c="x64") ; Virtual protect must always be enabled for both 32 and 64 bit. If DEP is set to all applications (not just systems), then this is required
DllCall("VirtualProtect", "ptr", p, "ptr", s, "uint", 0x40, "uint*", op)
if DllCall("crypt32\CryptStringToBinary", "str", m3, "uint", 0, "uint", e[m1], "ptr", p, "uint*", s, "ptr", 0, "ptr", 0)
return p
DllCall("GlobalFree", "ptr", p)
return
}

class _MEMORY_BASIC_INFORMATION
{
__new()
{
if !this.pStructure := DllCall("GlobalAlloc", "UInt", 0, "Ptr", this.SizeOfStructure := A_PtrSize = 8 ? 48 : 28, "Ptr")
return ""
return this
}
__Delete()
{
DllCall("GlobalFree", "Ptr", this.pStructure)
}

__get(key)
{
static aLookUp := A_PtrSize = 8
?   {   "BaseAddress": {"Offset": 0, "Type": "Int64"}
,    "AllocationBase": {"Offset": 8, "Type": "Int64"}
,    "AllocationProtect": {"Offset": 16, "Type": "UInt"}
,    "RegionSize": {"Offset": 24, "Type": "Int64"}
,    "State": {"Offset": 32, "Type": "UInt"}
,    "Protect": {"Offset": 36, "Type": "UInt"}
,    "Type": {"Offset": 40, "Type": "UInt"} }
:   {  "BaseAddress": {"Offset": 0, "Type": "UInt"}
,   "AllocationBase": {"Offset": 4, "Type": "UInt"}
,   "AllocationProtect": {"Offset": 8, "Type": "UInt"}
,   "RegionSize": {"Offset": 12, "Type": "UInt"}
,   "State": {"Offset": 16, "Type": "UInt"}
,   "Protect": {"Offset": 20, "Type": "UInt"}
,   "Type": {"Offset": 24, "Type": "UInt"} }

if aLookUp.HasKey(key)
return numget(this.pStructure+0, aLookUp[key].Offset, aLookUp[key].Type)
}
__set(key, value)
{
static aLookUp := A_PtrSize = 8
?   {   "BaseAddress": {"Offset": 0, "Type": "Int64"}
,    "AllocationBase": {"Offset": 8, "Type": "Int64"}
,    "AllocationProtect": {"Offset": 16, "Type": "UInt"}
,    "RegionSize": {"Offset": 24, "Type": "Int64"}
,    "State": {"Offset": 32, "Type": "UInt"}
,    "Protect": {"Offset": 36, "Type": "UInt"}
,    "Type": {"Offset": 40, "Type": "UInt"} }
:   {  "BaseAddress": {"Offset": 0, "Type": "UInt"}
,   "AllocationBase": {"Offset": 4, "Type": "UInt"}
,   "AllocationProtect": {"Offset": 8, "Type": "UInt"}
,   "RegionSize": {"Offset": 12, "Type": "UInt"}
,   "State": {"Offset": 16, "Type": "UInt"}
,   "Protect": {"Offset": 20, "Type": "UInt"}
,   "Type": {"Offset": 24, "Type": "UInt"} }

if aLookUp.HasKey(key)
{
NumPut(value, this.pStructure+0, aLookUp[key].Offset, aLookUp[key].Type)
return value
}
}
Ptr()
{
return this.pStructure
}
sizeOf()
{
return this.SizeOfStructure
}
}
}


;-------------------------------------------------------
;-------제작 함수----------------------------------------
;-------------------------------------------------------

스킬사용(스킬이름)
{
	Gui,ListView,어빌리티리스트
	스킬번호 := 0
	mem.write(0x0058D603, 0x00, "Char", aOffsets*)
	Loop % LV_GetCount()
	{
		LV_GetText(skill_name, A_Index, 3)
		if (skill_name = 스킬이름)
		스킬번호 := A_Index
	}
	if (스킬번호 != 0)
	{
		mem.write(0x0058D603, 스킬번호, "Char", aOffsets*)
		sleep,10
		메모리실행("스킬사용")
	}
}

미니맵클릭하여좌표이동(input_x,input_y)
{
	미니맵x := mem.read(0x0058EB48, "UInt", 0x80)
	미니맵y := mem.read(0x0058EB48, "UInt", 0x84)
	맵번호 := mem.read(0x0058EB1C, "UInt", 0x10E)
	차원 := Get_Dimension()
	Gui,Submit,Nohide
	gui,listview,NPC리스트
	Loop, % LV_GetCount()
	{
		LV_GetText(블랙_차원, A_Index, 2)
		LV_GetText(블랙_맵번호, A_Index, 4)
		LV_GetText(블랙_x, A_Index, 7)
		LV_GetText(블랙_y, A_Index, 8)
		if (차원 = 블랙_차원 && 블랙_맵번호 = 맵번호 && input_x = 블랙_x && input_y = 블랙_y)
		{
			input_x := input_x - 2
			input_y := input_y + 1
		}
	}
	;분류|차원|맵이름|번호|이름|OID|X|Y|Z|우선순위|주소

	scale_factor_x := 2
	scale_factor_y := 2
	if(맵번호 = 237)
	{
		translation_offset_x := 493
		translation_offset_y := 479
	}
	else if(맵번호 = 3300 || 맵번호 = 3301)
	{
		translation_offset_x := 80
		translation_offset_y := 60
	}
	else if(맵번호 = 2300 )
	{
		translation_offset_x := 594
		translation_offset_y := 400
	}
	else if(맵번호 = 1403 )
	{
		translation_offset_x := 594
		translation_offset_y := 400
	}
	else
	{
		translation_offset_x := 80
		translation_offset_y := 60
	}
	output_x := input_x * scale_factor_x - translation_offset_x + 미니맵x
	output_y := input_y * scale_factor_y - translation_offset_y + 미니맵y
	sleep,10
	마우스클릭(output_x, output_y)
}

Mapreopen()
{
	Gui,Submit,Nohide
	;WinGet,PID,PID,%TargetTitle%
	PID := TPID
	if(UiTest(1) = 0 )
	{
		PostMessage, 0x100, 0xA4, 0,,ahk_pid %pid%
		PostMessage, 0x100, 0x56, 3080193,,ahk_pid %pid%
		PostMessage, 0x101, 0xA4, 0,,ahk_pid %pid%
		MapBig := mem.read(0x0058DAD0, "UInt", 0xC, 0x10, 0x8, 0x264)
		MapNumber:= mem.read(0x0058EB1C, "UInt", 0x10E)
		if( MapNumber = 237 && MapBig!=1)
		{
			sleep, 100
			마우스클릭(725, 484)
		}
	}
}

UiTest(TestNum)
{
	if(TestNum = 1)
	{
		UIMap := mem.read(0x0058EB6C, "UInt", aOffsets*)
		sleep, 1
		return UIMap
	}
	else if(TestNum = 2)
	{
		UIRas := mem.read(0x0058F0CC, "UInt", aOffsets*)
		return UIRas
	}
}

IsDataInList(data, list)
{
	for _, item in list
	{
		if (item = data)
		return true
	}
	return false
}

ReadAbilityNameValue()
{
	AbilityName := jelan.readString(AbilityNameADD, 20, "UTF-16", aOffsets*)
	AbilityValue := jelan.read(AbilityValueADD, "UShort", aOffsets*)
}

AddTo원하는아이템(분류, 차원, 맵이름, 번호, 아이템이름, OID, X, Y, Z, 주소)
{
	gui, listview, 원하는아이템리스트
	Loop % LV_GetCount()
	{
		LV_GetText(원하는아이템이름, A_index)
		sb_settext(원하는아이템이름 "/" 아이템이름, 2)
		if (원하는아이템이름 != "") && ifinstring, 아이템이름, %원하는아이템이름%
		{
			IsNewOID := True
			gui, listview, 목표리스트
			loop % LV_GetCount()
			{
				LV_GetText(기존_object_id, A_Index, 6)
				if(기존_object_id = OID)
				{
					LV_Modify(A_Index, "", 분류, 차원, 맵이름, 번호, 아이템이름, OID, X, Y, Z, 주소)
					IsNewOID := False
				}
			}
			if IsNewOID
				LV_Add("", 분류, 차원, 맵이름, 번호, 아이템이름, OID, X, Y, Z, 주소)
		}
	}
}

RemoveFrom목표리스트(D분류,DOID)
{
	gui,listview,아이템리스트
	IsExistInItemList := False
	loop % LV_GetCount()
	{
		LV_GetText(목표OID, A_Index, 6)
		if(목표OID = DOID)
		IsExistInItemList := True
	}
	return IsExistInItemList
}

Search_Book(Num)
{
	Freeze_Move()
	BookX := mem.Read(0x0058EB48, "Uint", 0x164) - 99
	BookY := mem.Read(0x0058EB48, "Uint", 0x168) - 117
	X1 := BookX + 27
	Y1 := BookY + 45
	Y2 := Y1 + 36
	Y3 := Y2 + 36
	Y4 := Y3 + 36
	Y5 := Y4 + 36
	MoveX := BookX + 148
	MoveY := BookY + 207
	STOPSIGN := True
	if(Num = 0)
	마우스클릭(MoveX,MoveY)
	else if(Num = 1)
	{
		마우스클릭(X1,Y1)
		sleep,100
		마우스클릭(MoveX,MoveY)
	}
	else if(Num =2)
	{
		마우스클릭(X1,Y2)
		sleep,100
		마우스클릭(MoveX,MoveY)
	}
	else if(Num =3)
	{
		마우스클릭(X1,Y3)
		sleep,100
		마우스클릭(MoveX,MoveY)
	}
	else if(Num =4)
	{
		마우스클릭(X1,Y4)
		sleep,100
		마우스클릭(MoveX,MoveY)
	}
	else if(Num =5)
	{
		마우스클릭(X1,Y5)
		sleep,100
		마우스클릭(MoveX,MoveY)
	}
	sleep, 300
	Un_Freeze_Move()
	STOPSIGN := False
}

수련용길탐(Num)
{
	BookX := mem.Read(0x0058EB48, "Uint", 0x164) - 99
	BookY := mem.Read(0x0058EB48, "Uint", 0x168) - 117
	X1 := BookX + 27
	Y1 := BookY + 45
	Y2 := Y1 + 36
	Y3 := Y2 + 36
	Y4 := Y3 + 36
	Y5 := Y4 + 36
	MoveX := BookX + 148
	MoveY := BookY + 207
	if(Num = 0)
		마우스클릭(MoveX,MoveY)
	else if(Num = 1)
	{
		마우스클릭(X1,Y1)
		sleep,100
		마우스클릭(MoveX,MoveY)
	}
	else if(Num =2)
	{
		마우스클릭(X1,Y2)
		sleep,100
		마우스클릭(MoveX,MoveY)
	}
	else if(Num =3)
	{
		마우스클릭(X1,Y3)
		sleep,100
		마우스클릭(MoveX,MoveY)
	}
	else if(Num =4)
	{
		마우스클릭(X1,Y4)
		sleep,100
		마우스클릭(MoveX,MoveY)
	}
	else if(Num =5)
	{
		마우스클릭(X1,Y5)
		sleep,100
		마우스클릭(MoveX,MoveY)
	}
}

CallNPC(호출할NPC)
{
	sleep,1000
	맵번호 := mem.read(0x0058EB1C, "UInt", 0x10E)
	차원 := Get_Dimension()
	비교번호 := 0
	if (호출할NPC = "성검사")
	{
	비교번호 := 269
	}
	else if (호출할NPC = "동쪽파수꾼")
	{
	비교번호 := 4005
	}
	else if (호출할NPC = "서쪽파수꾼")
	{
	비교번호 := 4005
	}
	else if (호출할NPC = "길잃은수색대")
	{
	비교번호 := 4003
	}
	else if (호출할NPC = "행운장")
	{
	비교번호 := 201
	}
	else if (호출할NPC = "에레노아")
	{
	비교번호 := 219
	}
	else if (호출할NPC = "카로에")
	{
	비교번호 := 1219
	}
	else if (호출할NPC = "백작")
	{
	비교번호 := 2219
	}
	else if (호출할NPC = "마데이아")
	{
	비교번호 := 3219
	}
	else if (호출할NPC = "리노스")
	{
	비교번호 := 4219
	}
	else if (호출할NPC = "쿠키")
	{
	비교번호 := 4200
	}
	else if (호출할NPC = "키아")
	{
	비교번호 := 4213
	}
	else if (호출할NPC = "카딜라")
	{
	비교번호 := 204
	}
	if (맵번호 = 비교번호)
	{
		NPCOID := ""
		gui,listview,NPC리스트
		Loop % LV_GetCount()
		{
			LV_GetText(NPC차원,A_index,2)
			LV_GetText(NPC이름,A_index,5)
			if (NPC차원 = 차원 && NPC이름 = 호출할NPC )
			{
			LV_GetText(NPCOID,A_index,6)
				break
			}
			else if (NPC차원 = 차원) && InStr(NPC이름, 호출할NPC)
			{
				LV_GetText(NPCOID,A_index,6)
				break
			}
		}
		sleep, 100
		if(NPCOID != "")
		{
			메모리권한변경및쓰기("NPC호출용1")
			메모리권한변경및쓰기("NPC호출용2")
			mem.write(0x00527b54, NPCOID, "UInt", aOffset*)
			sleep, 1000
			메모리실행("NPC호출")
			SB_SETTEXT(호출할NPC "(" NPCOID ") 호출" , "2")
		}
		sleep, 300
	}
}

마우스클릭(X,Y)
{
	pid := TargetPid
	if (Multiplyer = "없음" || Multiplyer < 1)
		gosub, 일랜시아창크기구하기
	MouseX := X * Multiplyer
	MouseY := Y * Multiplyer
	MousePos := MouseX|MouseY<< 16
	PostMessage, 0x200, 0, %MousePos% ,,ahk_pid %pid%
	PostMessage, 0x201, 1, %MousePos% ,,ahk_pid %pid%
	PostMessage, 0x202, 0, %MousePos% ,,ahk_pid %pid%
}

add_은행넣을아이템대기리스트(아이템)
{
	gui, listview, 은행넣을아이템대기리스트
	Loop % LV_GetCount()
	{
		LV_GetText(기존아이템,A_index,1)
		if(기존아이템 = 아이템)
			return
	}
	LV_add("",아이템)
}

add_소각할아이템대기리스트(아이템)
{
	gui, listview, 소각할아이템대기리스트
	Loop % LV_GetCount()
	{
		LV_GetText(기존아이템,A_index,1)
		if(기존아이템 = 아이템)
			return
	}
	LV_add("",아이템)
}

행깃기록(NPCMsgGet)
{
	; 초기화
	itemDatabase := {}  ; 아이템 데이터베이스 초기화
	OutputFile := a_scriptdir . "\SaveOf" . TargetTitle . "\item_inventory.txt"  ; 메모장 파일 이름
	; 기존 데이터 로드
	if FileExist(OutputFile)
	{
		FileRead, existingData, %OutputFile%
		Loop, Parse, existingData, `n
		{
			IfInString, A_LoopField, :
			{
				itemData := StrSplit(A_LoopField, ":")  ; 아이템 이름과 수량 분리
				if (itemData.Length() = 2)  ; 올바른 형식인 경우
				{
					item := Trim(itemData[1])  ; 아이템 이름 공백 제거
					count := RegExReplace(Trim(itemData[2]),"[^0-9]") ; 수량 공백 제거
					itemDatabase[item] := count
				}
			}
		}
	}

	if !FileExist(OutputFile)
	{
		FileAppend,, %OutputFile%
	}

	if RegExMatch(NPCMsgGet, "\[([^]]+)\]", ItemMatch)
	{
		ItemName := ItemMatch1
		; 아이템 데이터베이스에서 아이템 찾기
		if (itemDatabase.HasKey(ItemName))
		{
		; 이미 저장된 아이템인 경우 수량 증가
		itemDatabase[ItemName]++
		}
		else
		{
		; 새로운 아이템인 경우 수량 1로 초기화
		itemDatabase[ItemName] := 1
		}
		; 메모장에 아이템 데이터베이스 저장
		FileDelete, %OutputFile%
		for ItemName, ItemCount in itemDatabase
		{
		FileAppend, %ItemName%:%ItemCount%`n, %OutputFile%
		}
	}
}

Move_Buy()
{
	mem.write(0x0058EB48, 233, "UInt", 0x8C)
	mem.write(0x0058EB48, 173, "UInt", 0x90)
}

Move_Sell()
{
	mem.write(0x0058EB48, 233, "UInt", 0x98)
	mem.write(0x0058EB48, 173, "UInt", 0x9C)
}

Move_Repair()
{
	mem.write(0x0058EB48, 230, "UInt", 0xA4)
	mem.write(0x0058EB48, 170, "UInt", 0xA8)
}

Buy_Unlimitted()
{
	mem.write(0x0042483A, 0xB0, "char", aOffsets*)
	mem.write(0x0042483B, 0x01, "char", aOffsets*)
	mem.write(0x0042483C, 0x90, "char", aOffsets*)
	mem.write(0x0042483D, 0x90, "char", aOffsets*)
	mem.write(0x0042483E, 0x90, "char", aOffsets*)
	mem.write(0x0042483F, 0x90, "char", aOffsets*)
}

Freeze_Move()
{
	mem.write(0x0047AD78, 0x90, "char", aOffsets*)
	mem.write(0x0047AD79, 0x90, "char", aOffsets*)
	mem.write(0x0047AD7A, 0x90, "char", aOffsets*)
}

Un_Freeze_Move()
{
	mem.write(0x0047AD78, 0x8B, "char", aOffsets*)
	mem.write(0x0047AD79, 0x4E, "char", aOffsets*)
	mem.write(0x0047AD7A, 0x04, "char", aOffsets*)
}

inputallsellers(NPCTYPE)
{
	gui, submit, nohide
	IfWinNotActive, %TargetTitle%
	{
		WinActivate,%TargetTitle%
		sleep,30
	}
	Send, !m
	Sleep,500
	ime_status := % IME_CHECK("A")
	if (ime_status = "0")
	{
		Send,{vk15sc138}
		Sleep,100
	}
	if NPCTYPE = COOK
		send, zkelffk{space}apsb{tab}tb{space}apsb{tab}zhvp{space}apsb{tab}tispxm{space}apsb{tab}qptm{space}apsb{tab}znzl{space}apsb{tab}zkfpvn{space}apsb{tab}dhdlvlsh{space}apsb{enter}
	else if NPCTYPE = INK
		send, tpslzh{space}apsb{tab}slzl{space}apsb{tab}zmfhfltm{space}apsb{tab}goddnswkd{space}apsb{tab}dpaxhvh{space}apsb{enter}
	else if NPCTYPE = PANT
		send, vmffksh{space}apsb{tab}xpel{space}apsb{tab}alshtm{space}apsb{tab}vhql{space}apsb{enter}
	sleep,3
}

Check_Shop(what)
{
	if(what="Buy")
	{
		Result := mem.read(0x0058EBB8, "UInt", aOffsets*)
		return Result
	}
	else if(what="Repair")
	{
		Result :=  mem.read(0x0058F0C0, "UInt", aOffsets*)
		return Result
	}
	else if(what="Sell")
	{
		Result := mem.read(0x0058F0C4, "UInt", aOffsets*)
		return Result
	}
	return
}

NPCMENUSELECT(what)
{
	ErrorLevel_check := 0
	loop, 5
	{
		NpcMenuSelection := mem.read(0x0058F0A4, "UInt", aOffset*)
		if NpcMenuSelection = 0
			sleep, 100
		else
			break
	}
	if (what = "Buy")
	{
		X := mem.read(0x0058F0A4, "UInt", 0x9A) +10
		Y := mem.read(0x0058F0A4, "UInt", 0x9E) +15
	}
	else if (what = "Sell")
	{
		X := mem.read(0x0058F0A4, "UInt", 0x9A) +31
		Y := mem.read(0x0058F0A4, "UInt", 0x9E) +15
	}
	else if (what = "Repair")
	{
		X := mem.read(0x0058F0A4, "UInt", 0x9A) +55
		Y := mem.read(0x0058F0A4, "UInt", 0x9E) +15
	}
	else if (what = "Talk")
	{
		X := mem.read(0x0058F0A4, "UInt", 0x9A) +76
		Y := mem.read(0x0058F0A4, "UInt", 0x9E) +15
	}
	loop,1 {
		마우스클릭(x,y)
		sleep,100
	}
}

NPCMENUCLICK(what,key)
{
	ErrorLevel_check := 0
	loop,
	{
		NPCMenu := mem.read(0x0058F0A4, "UInt", aOffsets*)
		if Coin!=1
			break
		if(NPCMenu != 0)
		{
			break
		}
		else if(NPCMenu =0)
		{
			ErrorLevel_check++
			sleep, 500
			if(ErrorLevel_check >5)
			{
				keyclick(key)
				ErrorLevel_check:=0
			}
		}
	}
	if (what = "Buy")
	{
		X := mem.read(0x0058F0A4, "UInt", 0x9A) +10
		Y := mem.read(0x0058F0A4, "UInt", 0x9E) +15
	}
	else if (what = "Sell")
	{
		X := mem.read(0x0058F0A4, "UInt", 0x9A) +31
		Y := mem.read(0x0058F0A4, "UInt", 0x9E) +15
	}
	else if (what = "Repair")
	{
		X := mem.read(0x0058F0A4, "UInt", 0x9A) +55
		Y := mem.read(0x0058F0A4, "UInt", 0x9E) +15
	}
	else if (what = "Talk")
	{
		X := mem.read(0x0058F0A4, "UInt", 0x9A) +76
		Y := mem.read(0x0058F0A4, "UInt", 0x9E) +15
	}

	loop,2
	{
		마우스클릭(x,y)
		sleep,100
	}
}

라깃사용하기(마을,목적차원)
{
	if (라스의깃갯수 < 1)
	{
		SB_SetText("라스의깃 소지 여부 확인필요", 2)
		return
	}
	라스의깃단축키 := 0
	KeyClick(라스의깃단축키)
	StopSign := True
	sleep, 100
	loop,
	{
		sleep,10
		if (라스의깃열려있는지확인() != 0)
			break
	}
	라스의깃마을선택(마을)
	loop,
	{
		sleep,10
		if (라스의깃마을선택됬는지확인() != 0)
			break
	}
	라스의깃차원선택(마을,목적차원)
	return
}

라스의깃열려있는지확인()
{
result := mem.read(0x0058F0CC, "UInt", aOffsets*)
return result
; 0 닫힘
; != 0 열림
}

라스의깃마을선택됬는지확인()
{
result := mem.read(0x0058F100, "UInt", aOffsets*)
return result
; 0 안됨
; != 0 됨
}

라스의깃마을선택(마을)
{
	If (마을 = "로랜시아")
	{
		마우스클릭(270,370)
	}
	else If (마을 = "에필로리아")
	{
		마우스클릭(275,205)
	}
	else If (마을 = "세르니카")
	{
		마우스클릭(545,140)
	}
	else If (마을 = "크로노시스")
	{
		마우스클릭(430,405)
	}
	else If (마을 = "포프레스네")
	{
		마우스클릭(630,365)
	}
}

라스의깃차원선택(마을,목적차원)
{
	If (마을 = "로랜시아")
	{
		차원X := 273
	}
	else If (마을 = "에필로리아")
	{
		차원X := 278
	}
	else If (마을 = "세르니카")
	{
		차원X := 546
	}
	else If (마을 = "크로노시스")
	{
		차원X := 434
	}
	else If (마을 = "포프레스네")
	{
		차원X := 631
	}
	if (목적차원 = "베타")
		차원X += 14
	else if (목적차원 = "감마")
		차원X += 28
	If (마을 = "로랜시아")
	{
		마우스클릭(차원X,347)
	}
	else If (마을 = "에필로리아")
	{
		마우스클릭(차원X,187)
	}
	else If (마을 = "세르니카")
	{
		마우스클릭(차원X,120)
	}
	else If (마을 = "크로노시스")
	{
		마우스클릭(차원X,384)
	}
	else If (마을 = "포프레스네")
	{
		마우스클릭(차원X,345)
	}
}

Check_FormNumber()
{
	FormNumber := mem.read(0x0058DAD0, "UInt", 0xC, 0x10, 0x8, 0xA0)
	Return FormNumber
}

Check_NPCMsg_lucky()
{
	ADR := NPC_MSG_ADR - 0x274
	NPCMsg :=  mem.readString(ADR, 50, "UTF-16", aOffsets*)
	Return NPCMsg
}

Check_NPCMsg_address()
{
	SetFormat, Integer, H
	KeyClick("F1")
	startAddress := 0x00100000
	endAddress := 0x00200000
	sleep, 1000
	NPCMsg_address := mem.processPatternScan(startAddress, endAddress, 0x3A, 0x00, 0x20, 0x00, 0xE4, 0xB9, 0x6C, 0xD0, 0x5C, 0xB8, 0x20, 0x00, 0x20, 0x00, 0x20, 0x00, 0x20)
	sleep, 1000
	KeyClick("F1")
	SetFormat, Integer, D
	SB_SetText(NPCMsg_address,1)
	GuiControl,, NPC_MSG_ADR, %NPCMsg_address%
	return NPCMsg_address
}

Check_NPCMsg()
{
	;NPCMsg := mem.readString(0x0017E4EC, 50, "UTF-16", aOffsets*)
	ADR := NPC_MSG_ADR
	NPCMsg := mem.readString(ADR, 50, "UTF-16", aOffsets*)
	;SB_SetText(NPCMsg,2)
	Return NPCMsg
}

get_NPCTalk_cordi()
{
	x := mem.read(0x0058EB48, "UInt", 0xC8)
	y := mem.read(0x0058EB48, "UInt", 0xCC)
	Result := {"x":x, "y":y}
	Return Result
}

IME_CHECK(WinTitle)
{
	WinGet,hWnd,ID,%WinTitle%
	Return Send_ImeControl(ImmGetDefaultIMEWnd(hWnd),0x005,"")
}

Send_ImeControl(DefaultIMEWnd, wParam, lParam)
{
DetectSave := A_DetectHiddenWindows
DetectHiddenWindows,ON
SendMessage 0x283, wParam,lParam,,ahk_id %DefaultIMEWnd%
if (DetectSave <> A_DetectHiddenWindows)
	DetectHiddenWindows,%DetectSave%
return ErrorLevel
}

ImmGetDefaultIMEWnd(hWnd)
{
	return DllCall("imm32\ImmGetDefaultIMEWnd", Uint,hWnd, Uint)
}

DB_RECORD(kind,newMapNumber,newMapName,newName,newImageNumber,newX := 0,newY := 0,newZ := 0) 	;인게임 DB수집용 공개할때는 없애야 하는 함수
{
	if (kind == "고용상인")
		return
	else
		FileName := "DB_DATA.ini"
	; INI 파일에서 해당 이름의 데이터를 읽어옵니다.
	IniRead, existingData, %FileName%, Names, %newName%
	; 데이터가 없다면 새로운 데이터를 추가합니다.
	if (ErrorLevel = 0 || existingData = "")
	{
		; 새로운 데이터를 하나의 문자열로 만듭니다.
		newDataRow := newMapNumber . "," . newMapName . "," . newImageNumber . "," . newX . "," . newY . "," . newZ
		; 데이터를 INI 파일에 씁니다.
		IniWrite, %newDataRow%, %FileName%, Names, %newName%
		;SB_SetText("DB_Recrd" newName ,2)
	}
	IniRead, existingData, %FileName%, Images, %newImageNumber%
	if (ErrorLevel = 0 || existingData = "")
	{
		; 새로운 데이터를 하나의 문자열로 만듭니다.
		newDataRow := newName . "," . newMapNumber . "," . newMapName . "," . newX . "," . newY . "," . newZ
		; 데이터를 INI 파일에 씁니다.
		IniWrite, %newDataRow%, %FileName%, Images, %newImageNumber%
		;SB_SetText("DB_Recrd" newName ,2)
	}
}

;YouTube예제; *사용하기
Setting_DELETE(type, targetItem*)
{
    FileName := a_scriptdir . "\SaveOf" . TargetTitle . "\Char_Setting.ini"
    if (type = "NPC리스트")
        FileName := "NPCList.ini"
    IniRead, allitems, %FileName%, %type%
    itemList := StrSplit(allitems, "`n")

    newItems := {} ; 새로운 아이템을 저장할 배열

    for index, coord in itemList
    {
        IniRead, existingData, %FileName%, %type%, %A_index%
        fields := StrSplit(existingData, ",")

        if (fields[1] = targetItem[1] && type != "NPC리스트") || (fields[2] = targetItem[2] && fields[5] = targetItem[5] && fields[6] = targetItem[6] && type = "NPC리스트")
        {
            ; 삭제 대상이므로 스킵합니다.
        }
        else
        {
            ; 삭제 대상이 아니므로 새 배열에 추가합니다.
            newItems.Push(existingData)
        }
    }

    ; 기존의 모든 행을 삭제합니다.
    IniDelete, %FileName%, %type%

    ; 새로운 아이템을 다시 씁니다.
    index := 1
    for a, item in newItems
    {
        IniWrite, %item%, %FileName%, %type%, %index%
        index++
    }
}

Setting_RECORD(type,itemname*)
{
	저장위치 := a_scriptdir . "\SaveOf" . TargetTitle
	if (TargetTitle != "") && !FileExist(저장위치)
	{
		temp_foldername := "SaveOf" . TargetTitle
		FileCreateDir, %temp_foldername%
	}
	found := false
	FileName := a_scriptdir . "\SaveOf" . TargetTitle . "\Char_Setting.ini"
	if (type = "NPC리스트")
		FileName := "NPCList.ini"
	IniRead, allitems, %FileName%, %type%
	; 데이터가 없다면 새로운 데이터를 추가합니다.
	itemList := StrSplit(allitems, "`n") ; 줄 바꿈으로 분리하여 배열에 저장합니다.

	; 각 이름에 대한 데이터를 확인합니다.
	for index, coord in itemList
	{
		IniRead, existingData, %FileName%, %type%, %A_index%

		; 데이터를 쉼표로 분리하여 각 필드를 얻습니다.
		fields := StrSplit(existingData, ",")

		; X, Y, Z 값이 일치하는지 확인합니다.
		if (fields[1] = itemname[1]) && (type != "NPC리스트")
		{
			found := true
			break
		}
		else if (fields[5] = itemname[5]) && (type = "NPC리스트") && (fields[2] = itemname[2])
		{
			if(fields[6] = itemname[6])
			{
				found := true
				break
			}
			else (fields[6] != itemname[6])
			{
				FileDelete, %FileName%
				gui, listview, NPC리스트
				LV_delete()
			}
		}
		Last := A_index
	}
	Last += 1
	; 일치하는 데이터가 없다면 새로운 데이터를 추가합니다.
	if (!found)
	{
		; 새로운 데이터를 하나의 문자열로 만듭니다.
		i := 1
		for index, item in itemname
		{
			if (i > 1)
			newDataRow .= ","
			i++
			newDataRow .= item
		}
		; 데이터를 INI 파일에 씁니다.
		IniWrite, %newDataRow%, %FileName%, %type%, %Last%
	}
	; INI 파일에서 해당 이름의 데이터를 읽어옵니다.
}

;YouTube예제; *사용하지 않기
DB_RECORD_Coord(Mapnumber,MapName,x,y,z)
{
	FileName := "DB_DATA_Coord.ini"
	; INI 파일에서 해당 이름의 데이터를 읽어옵니다.
	found := false
	IniRead, allMaps, %FileName%, %Mapnumber%
	; 데이터가 없다면 새로운 데이터를 추가합니다.
	MapList := StrSplit(allMaps, "`n") ; 줄 바꿈으로 분리하여 배열에 저장합니다.

	; 각 이름에 대한 데이터를 확인합니다.
	for index, coord in MapList
	{
		IniRead, existingData, %FileName%, %Mapnumber%, %A_index%

		; 데이터를 쉼표로 분리하여 각 필드를 얻습니다.
		fields := StrSplit(existingData, ",")

		; X, Y, Z 값이 일치하는지 확인합니다.
		if (fields[4] = x && fields[5] = y && fields[6] = z)
		{
			found := true
			break
		}
		Last := A_index
	}
	Last += 1
	; 일치하는 데이터가 없다면 새로운 데이터를 추가합니다.
	if (!found)
	{
		; 새로운 데이터를 하나의 문자열로 만듭니다.
		newDataRow := Mapnumber . "," . Last . "," . MapName . "," . x . "," . y . "," . z

		; 데이터를 INI 파일에 씁니다.
		IniWrite, %newDataRow%, %FileName%, %Mapnumber%, %Last%
	}
}

DB_RECORD_Delete(Mapnumber, MapName, x, y, z)
{
    FileName := "DB_DATA_Coord.ini"
    found := false
    IniRead, allMaps, %FileName%, %Mapnumber%
    MapList := StrSplit(allMaps, "`n")

    newMapList := {} ; 새로운 맵 리스트를 저장할 배열

    for index, coord in MapList
    {
        IniRead, existingData, %FileName%, %Mapnumber%, %A_index%
        fields := StrSplit(existingData, ",")

        if (fields[4] = x && fields[5] = y && fields[6] = z)
        {
            found := true
            ; 삭제 대상이므로 스킵합니다.
        }
        else
        {
            ; 삭제 대상이 아니면 새 배열에 추가합니다.
            newMapList.Push(existingData)
        }
    }

    ; 기존의 모든 행을 삭제합니다.
    IniDelete, %FileName%, %Mapnumber%

    ; 새로운 데이터를 다시 씁니다.
    index := 1
    for _, item in newMapList
    {
        IniWrite, %item%, %FileName%, %Mapnumber%, %index%
        index++
    }

    ; 일치하는 데이터가 없다면 새로운 데이터를 추가합니다.
    if (!found)
    {
        newDataRow := Mapnumber . "," . index . "," . MapName . "," . x . "," . y . "," . z
        IniWrite, %newDataRow%, %FileName%, %Mapnumber%, %index%
    }
}

LoadItemData(type)
{
	;NPC리스트
	;원하는아이템리스트
	;은행넣을아이템리스트
	;소각할아이템리스트
	;원하는몬스터리스트

	FileName := a_scriptdir . "\SaveOf" . TargetTitle . "\Char_Setting.ini"
	if (type = "NPC리스트")
		FileName := "NPCList.ini"
	IniRead, allitems, %FileName%, %type%
	itemList := StrSplit(allitems, "`n")
	for index, item in itemList
	{
		IniRead, existingData, %FileName%, %type%, %A_index%
		fields := StrSplit(existingData, ",")
		gui,listview,%type%
		LV_Add("", fields*)
	}
	return
}

LoadCoordData()
{
	Mapnumber := mem.read(0x0058EB1C, "UInt", 0x10E)
	temp_저장위치 := "DB_DATA_Coord.ini"

	IniRead, allMaps, %temp_저장위치%, %Mapnumber%
	MapList := StrSplit(allMaps, "`n")
	for index, coord in MapList
	{
		IniRead, existingData, %temp_저장위치%, %Mapnumber%, %A_index%
		fields := StrSplit(existingData, ",")
		fields[2] := A_index
		gui,listview,좌표리스트
		LV_Add("", fields*)
	}
	return
}

Set_MoveSpeed(Speed)
{
	value := mem.write(0x0058DAD4, Speed, "UInt", 0x178, 0x9C)
	value := mem.write(0x0058DAD4, Speed, "UInt", 0x178, 0x98)
}

Read_Elancia_Titles()
{
	jElanciaArray := []
	Winget, jElanciaArray, List, ahk_class Nexon.Elancia
	jElancia_Count := 0
	ElanTitles := ""
	loop, %jElanciaArray%
	{
		jElancia := jElanciaArray%A_Index%
		WinGetTitle,Title,ahk_id %jElancia%
		ElanTitles.= Title "|"
	}
}

Get_Dimension()
{
	Dimension := mem.read(0x0058EB1C, "UInt",0x10A)
	if(Dimension>20000)
		CharDimen:="감마"
	else if(Dimension>10000)
		CharDimen:="베타"
	else if(Dimension<10000)
		CharDimen:="알파"
	return CharDimen
}

좌표입력(x_value,y_value,z_value)
{
	MapNumber := mem.read(0x0058EB1C, "UInt", 0x10E)
	if ( MapNumber = 237 || MapNumber = 1403 || MapNumber = 2300 ||MapNumber = 3300 || MapNumber =  3301 || MapNumber =  11 )
	z_value := 1
	x_value := Format("0x{:08X}", x_value)
	y_value := Format("0x{:08X}", y_value)
	z_value := Format("0x{:08X}", z_value)
	mem.write(0x00590600, x_value, "UInt", aOffsets*)
	mem.write(0x00590604, y_value, "UInt", aOffsets*)
	mem.write(0x00590608, z_value, "UInt", aOffsets*)
}

UpdateItemInfo(kind, 차원, 맵이름, 맵번호, find_name, find_object_id, find_x, find_y, find_z, 중요도, result, findMID)
{
	gui,listview,NPC리스트
	Loop, % LV_GetCount()
	{
		LV_GetText(블랙_차원, A_Index, 2)
		LV_GetText(블랙_맵번호, A_Index, 4)
		LV_GetText(블랙_x, A_Index, 7)
		LV_GetText(블랙_y, A_Index, 8)
		if (차원 = 블랙_차원 && 블랙_맵번호 = 맵번호 && find_x = 블랙_x && find_y = 블랙_y)
		{
			return
		}
	}
	gui,listview,목표리스트
	Loop, % LV_GetCount()
	{
		LV_GetText(object_id, A_Index, 6)
		if (object_id = find_object_id)
		{
			return
		}
	}
	; 만약 일치하는 아이템을 찾지 못했다면, 새로운 아이템을 추가합니다.
	gui,listview,목표리스트
	LV_Add("", kind, 차원, 맵이름, 맵번호, find_name, find_object_id, find_x, find_y, find_z, 중요도, result, findMID)
}

NPC리스트추가(kind, 차원, 맵이름, 맵번호, find_name, find_object_id, find_x, find_y, find_z, 중요도, result, findMID)
{
	if (find_name = "" || find_object_id = "" || kind != "NPC")
		return
	Gui, Submit, Nohide
	type := "NPC리스트"
	Setting_RECORD(type, kind, 차원, 맵이름, 맵번호, find_name, find_object_id, find_x, find_y, find_z, 중요도, result, findMID)
	Gui, ListView, %type%
	LV_Delete()
	LoadItemData(type)
}

KeyClick(Key)
{
pid := TargetPID
if coin != 1
return
;sb_settext(TargetPID "," key ,2)
if(Key = "Enter"){
loop, 1 {
PostMessage, 0x100, 13, 1835009,, ahk_pid %pid% ; Enter Lock
PostMessage, 0x101, 13, 1835009,, ahk_pid %pid% ; Enter Release
sleep, 1
}
}
else if(Key = "Shift"){
loop, 1 {
PostMessage, 0x100, 16, 2752513,, ahk_pid %pid% ; Shift Lock
PostMessage, 0x101, 16, 2752513,, ahk_pid %pid% ; Shift Release
sleep, 1
}
}
else if(Key = "ㄱ"){
loop, 1 {
PostMessage, 0x100, 229, 1245185,, ahk_pid %pid%
PostMessage, 0x101, 229, 1245185,, ahk_pid %pid%
sleep, 1
}
}
else if(Key = "a"){
loop, 1 {
PostMessage, 0x100, 65, 1966081,, ahk_pid %pid%
PostMessage, 0x101, 65, 1966081,, ahk_pid %pid%
sleep, 1
}
}
else if(Key = "b"){
loop, 1 {
PostMessage, 0x100, 66, 3145729,, ahk_pid %pid%
PostMessage, 0x101, 66, 3145729,, ahk_pid %pid%
sleep, 1
}
}
else if(Key = "c"){
loop, 1 {
PostMessage, 0x100, 67, 3014657,, ahk_pid %pid%
PostMessage, 0x101, 67, 3014657,, ahk_pid %pid%
sleep, 1
}
}
else if(Key = "d"){
loop, 1 {
PostMessage, 0x100, 68, 2097153,, ahk_pid %pid%
PostMessage, 0x101, 68, 2097153,, ahk_pid %pid%
sleep, 1
}
}
else if(Key = "e"){
loop, 1 {
PostMessage, 0x100, 69, 1179649,, ahk_pid %pid%
PostMessage, 0x101, 69, 1179649,, ahk_pid %pid%
sleep, 1
}
}
else if(Key = "f"){
loop, 1 {
PostMessage, 0x100, 70, 2162689,, ahk_pid %pid%
PostMessage, 0x101, 70, 2162689,, ahk_pid %pid%
sleep, 1
}
}
else if(Key = "g"){
loop, 1 {
PostMessage, 0x100, 71, 2228225,, ahk_pid %pid%
PostMessage, 0x101, 71, 2228225,, ahk_pid %pid%
sleep, 1
}
}
else if(Key = "h"){
loop, 1 {
PostMessage, 0x100, 72, 2293761,, ahk_pid %pid%
PostMessage, 0x101, 72, 2293761,, ahk_pid %pid%
sleep, 1
}
}
else if(Key = "i"){
loop, 1 {
PostMessage, 0x100, 73, 1507329,, ahk_pid %pid%
PostMessage, 0x101, 73, 1507329,, ahk_pid %pid%
sleep, 1
}
}
else if(Key = "j"){
loop, 1 {
PostMessage, 0x100, 74, 2359297,, ahk_pid %pid%
PostMessage, 0x101, 74, 2359297,, ahk_pid %pid%
sleep, 1
}
}
else if(Key = "k"){
loop, 1 {
PostMessage, 0x100, 75, 2424833,, ahk_pid %pid%
PostMessage, 0x101, 75, 2424833,, ahk_pid %pid%
sleep, 1
}
}
else if(Key = "l"){
loop, 1 {
PostMessage, 0x100, 76, 2490369,, ahk_pid %pid%
PostMessage, 0x101, 76, 2490369,, ahk_pid %pid%
sleep, 1
}
}
else if(Key = "m"){
loop, 1 {
PostMessage, 0x100, 77, 3276801,, ahk_pid %pid%
PostMessage, 0x101, 77, 3276801,, ahk_pid %pid%
sleep, 1
}
}
else if(Key = "n"){
loop, 1 {
PostMessage, 0x100, 78, 3211265,, ahk_pid %pid%
PostMessage, 0x101, 78, 3211265,, ahk_pid %pid%
sleep, 1
}
}
else if(Key = "o"){
loop, 1 {
PostMessage, 0x100, 79, 1572865,, ahk_pid %pid%
PostMessage, 0x101, 79, 1572865,, ahk_pid %pid%
sleep, 1
}
}
else if(Key = "p"){
loop, 1 {
PostMessage, 0x100, 80, 1638401,, ahk_pid %pid%
PostMessage, 0x101, 80, 1638401,, ahk_pid %pid%
sleep, 1
}
}
else if(Key = "q"){
loop, 1 {
PostMessage, 0x100, 81, 1048577,, ahk_pid %pid%
PostMessage, 0x101, 81, 1048577,, ahk_pid %pid%
sleep, 1
}
}
else if(Key = "r"){
loop, 1 {
PostMessage, 0x100, 82, 1245185,, ahk_pid %pid%
PostMessage, 0x101, 82, 1245185,, ahk_pid %pid%
sleep, 1
}
}
else if(Key = "s"){
loop, 1 {
PostMessage, 0x100, 83, 2031617,, ahk_pid %pid%
PostMessage, 0x101, 83, 2031617,, ahk_pid %pid%
sleep, 1
}
}
else if(Key = "t"){
loop, 1 {
PostMessage, 0x100, 84, 1310721,, ahk_pid %pid%
PostMessage, 0x101, 84, 1310721,, ahk_pid %pid%
sleep, 1
}
}
else if(Key = "u"){
loop, 1 {
PostMessage, 0x100, 85, 1441793,, ahk_pid %pid%
PostMessage, 0x101, 85, 1441793,, ahk_pid %pid%
sleep, 1
}
}
else if(Key = "v"){
loop, 1 {
PostMessage, 0x100, 86, 3080193,, ahk_pid %pid%
PostMessage, 0x101, 86, 3080193,, ahk_pid %pid%
sleep, 1
}
}
else if(Key = "w"){
loop, 1 {
PostMessage, 0x100, 87, 1114113,, ahk_pid %pid%
PostMessage, 0x101, 87, 1114113,, ahk_pid %pid%
sleep, 1
}
}
else if(Key = "x"){
loop, 1 {
PostMessage, 0x100, 88, 2949121,, ahk_pid %pid%
PostMessage, 0x101, 88, 2949121,, ahk_pid %pid%
sleep, 1
}
}
else if(Key = "y"){
loop, 1 {
PostMessage, 0x100, 89, 1376257,, ahk_pid %pid%
PostMessage, 0x101, 89, 1376257,, ahk_pid %pid%
sleep, 1
}
}
else if(Key = "z"){
loop, 1 {
PostMessage, 0x100, 90, 2883585,, ahk_pid %pid%
PostMessage, 0x101, 90, 2883585,, ahk_pid %pid%
sleep, 1
}
}
else if(Key = "AltR"){
loop, 1 {
PostMessage, 0x100, 18, 540540929,, ahk_pid %pid% ; ALT Lock
PostMessage, 0x100, 82, 1245185,, ahk_pid %pid%  ; r Lock
PostMessage, 0x101, 82, 1245185,, ahk_pid %pid%  ; r release
PostMessage, 0x101, 18, 540540929,, ahk_pid %pid% ; ALT Release
sleep, 1
}
}
else if(Key = "Space"){
loop, 1 {
PostMessage, 0x100, 32, 3735553,, ahk_pid %pid%
PostMessage, 0x101, 32, 3735553,, ahk_pid %pid%
}
}
else if(Key = "Tab"){
loop, 1 {
PostMessage, 0x100, 9, 983041,, ahk_pid %pid%
PostMessage, 0x101, 9, 983041,, ahk_pid %pid%
}
}
else if(Key = "Alt2"){
loop, 1 {
PostMessage, 0x100, 18, 540540929,, ahk_pid %pid% ; ALT Lock
postmessage, 0x100, 50, 196609, ,ahk_pid %pid% ; 2 Key Lock
postmessage, 0x101, 50, 196609, ,ahk_pid %pid% ; 2 Key Release
PostMessage, 0x101, 18, 540540929,, ahk_pid %pid% ; ALT Release
sleep, 1
}
}
else if (Key>=0&&KEY<=9){
if (key=0)
key := 10
NUM := key - 1
mem.write(0x005279CD, NUM, "Char", aOffsets*)
메모리실행("퀵슬롯사용")
}
else if(Key="F1"){
loop, 1 {
postmessage, 0x100, 112, 3866625, ,ahk_pid %pid%
postmessage, 0x101, 112, 3866625, ,ahk_pid %pid%
sleep, 1
}
}
else if(Key="F2"){
loop, 1 {
postmessage, 0x100, 113, 3932161, ,ahk_pid %pid%
postmessage, 0x101, 113, 3932161, ,ahk_pid %pid%
sleep, 1
}
}
else if(Key="F3"){
loop, 1 {
postmessage, 0x100, 114, 3997697, ,ahk_pid %pid%
postmessage, 0x101, 114, 3997697, ,ahk_pid %pid%
sleep, 1
}
}
else if(Key="k1"){
loop, 1 {
postmessage, 0x100, 49, 131073, ,ahk_pid %pid% ; 1 Key Lock
postmessage, 0x101, 49, 131073, ,ahk_pid %pid% ; 1 Key Release
sleep, 1
}
}
else if(Key="k2") {
loop, 1 {
postmessage, 0x100, 50, 196609, ,ahk_pid %pid% ; 2 Key Lock
postmessage, 0x101, 50, 196609, ,ahk_pid %pid% ; 2 Key Release
sleep, 1
}
}
else if(Key="k3") {
loop, 1 {
postmessage, 0x100, 51, 262145, ,ahk_pid %pid% ; 3 Key Lock
postmessage, 0x101, 51, 262145, ,ahk_pid %pid% ; 3 Key Release
sleep, 1
}
}
else if(Key="k4") {
loop, 1 {
postmessage, 0x100, 52, 327681, ,ahk_pid %pid% ; 4 Key Lock
postmessage, 0x101, 52, 327681, ,ahk_pid %pid% ; 4 Key Release
sleep, 1
}
}
else if(Key="k5"){
loop, 1{
postmessage, 0x100, 53, 393217, ,ahk_pid %pid% ; 5 Key Lock
postmessage, 0x101, 53, 393217, ,ahk_pid %pid% ; 5 Key Release
sleep, 1
}
}
else if(Key="k6"){
loop, 1{
postmessage, 0x100, 54, 458753, ,ahk_pid %pid% ; 6 Key Lock
postmessage, 0x101, 54, 458753, ,ahk_pid %pid% ; 6 Key Release
sleep, 1
}
}
else if(Key="k7"){
loop, 1{
postmessage, 0x100, 55, 524289, ,ahk_pid %pid% ; 7 Key Lock
postmessage, 0x101, 55, 524289, ,ahk_pid %pid% ; 7 Key Release
sleep, 1
}
}
else if(Key="k8"){
loop, 1{
postmessage, 0x100, 56, 589825, ,ahk_pid %pid% ; 8 Key Lock
postmessage, 0x101, 56, 589825, ,ahk_pid %pid% ; 8 Key Release
sleep, 1
}
}
else if(Key="k9"){
loop, 1{
postmessage, 0x100, 57, 655361, ,ahk_pid %pid% ; 9 Key Lock
postmessage, 0x101, 57, 655361, ,ahk_pid %pid% ; 9 Key Release
sleep, 1
}
}
else if(Key="k0"){
loop, 1{
postmessage, 0x100, 48, 720897, ,ahk_pid %pid% ; 0 Key Lock
postmessage, 0x101, 48, 720897, ,ahk_pid %pid% ; 0 Key Release
sleep, 1
}
}
else if(Key="CTRL1"){
loop, 1 {
postmessage, 0x100, 17, 1900545, ,ahk_pid %pid% ; CTRL Lock
postmessage, 0x100, 49, 131073, ,ahk_pid %pid% ; 1 Key Lock
postmessage, 0x101, 49, 131073, ,ahk_pid %pid% ; 1 Key Release
postmessage, 0x101, 17, 1900545, ,ahk_pid %pid% ; CTRL Release
sleep, 1
}
}
else if(Key="CTRL2"){
loop, 1 {
postmessage, 0x100, 17, 1900545, ,ahk_pid %pid% ; CTRL Lock
postmessage, 0x100, 50, 196609, ,ahk_pid %pid% ; 2 Key Lock
postmessage, 0x101, 50, 196609, ,ahk_pid %pid% ; 2 Key Release
postmessage, 0x101, 17, 1900545, ,ahk_pid %pid% ; CTRL Release
sleep, 1
}
}
else if(Key="CTRL3") {
loop, 1 {
postmessage, 0x100, 17, 1900545, ,ahk_pid %pid% ; CTRL Lock
postmessage, 0x100, 51, 262145, ,ahk_pid %pid% ; 3 Key Lock
postmessage, 0x101, 51, 262145, ,ahk_pid %pid% ; 3 Key Release
postmessage, 0x101, 17, 1900545, ,ahk_pid %pid% ; CTRL Release
sleep, 1
}
}
else if(Key="CTRL4") {
loop, 1 {
postmessage, 0x100, 17, 1900545, ,ahk_pid %pid% ; CTRL Lock
postmessage, 0x100, 52, 327681, ,ahk_pid %pid% ; 4 Key Lock
postmessage, 0x101, 52, 327681, ,ahk_pid %pid% ; 4 Key Release
postmessage, 0x101, 17, 1900545, ,ahk_pid %pid% ; CTRL Release
sleep, 1
}
}
else if(Key="CTRL5") {
loop, 1 {
postmessage, 0x100, 17, 1900545, ,ahk_pid %pid% ; CTRL Lock
postmessage, 0x100, 53, 393217, ,ahk_pid %pid% ; 5 Key Lock
postmessage, 0x101, 53, 393217, ,ahk_pid %pid% ; 5 Key Release
postmessage, 0x101, 17, 1900545, ,ahk_pid %pid% ; CTRL Release
sleep, 1
}
}
else if(Key="CTRL6") {
loop, 1 {
postmessage, 0x100, 17, 1900545, ,ahk_pid %pid% ; CTRL Lock
postmessage, 0x100, 54, 458753, ,ahk_pid %pid% ; 6 Key Lock
postmessage, 0x101, 54, 458753, ,ahk_pid %pid% ; 6 Key Release
postmessage, 0x101, 17, 1900545, ,ahk_pid %pid% ; CTRL Release
sleep, 1
}
}
else if(Key="CTRL7") {
loop, 1 {
postmessage, 0x100, 17, 1900545, ,ahk_pid %pid% ; CTRL Lock
postmessage, 0x100, 55, 524289, ,ahk_pid %pid% ; 7 Key Lock
postmessage, 0x101, 55, 524289, ,ahk_pid %pid% ; 7 Key Release
postmessage, 0x101, 17, 1900545, ,ahk_pid %pid% ; CTRL Release
sleep, 1
}
}
else if(Key="CTRL8") {
loop, 1 {
postmessage, 0x100, 17, 1900545, ,ahk_pid %pid% ; CTRL Lock
postmessage, 0x100, 56, 589825, ,ahk_pid %pid% ; 8 Key Lock
postmessage, 0x101, 56, 589825, ,ahk_pid %pid% ; 8 Key Release
postmessage, 0x101, 17, 1900545, ,ahk_pid %pid% ; CTRL Release
sleep, 1
}
}
else if(Key="CTRL9") {
loop, 1 {
postmessage, 0x100, 17, 1900545, ,ahk_pid %pid% ; CTRL Lock
postmessage, 0x100, 57, 655361, ,ahk_pid %pid% ; 9 Key Lock
postmessage, 0x101, 57, 655361, ,ahk_pid %pid% ; 9 Key Release
postmessage, 0x101, 17, 1900545, ,ahk_pid %pid% ; CTRL Release
sleep, 1
}
}
else if(Key="CTRL0") {
loop, 1 {
postmessage, 0x100, 17, 1900545, ,ahk_pid %pid% ; CTRL Lock
postmessage, 0x100, 48, 720897, ,ahk_pid %pid% ; 0 Key Lock
postmessage, 0x101, 48, 720897, ,ahk_pid %pid% ; 0 Key Release
postmessage, 0x101, 17, 1900545, ,ahk_pid %pid% ; CTRL Release
sleep, 1
}
}
else if(Key="DownArrow") {
loop, 1 {
postmessage, 0x100, 40, 22020097, ,ahk_pid %pid% ; 하향 키 Lock
postmessage, 0x101, 40, 22020097, ,ahk_pid %pid% ; 하향 키 Release
sleep, 1
}
}
else if(Key="UpArrow") {
loop, 1 {
postmessage, 0x100, 38, 21495809, ,ahk_pid %pid% ; 상향 키 Lock
postmessage, 0x101, 38, 21495809, ,ahk_pid %pid% ; 상향 키 Release
sleep, 1
}
}
else if(Key="RightArrow") {
loop, 1 {
postmessage, 0x100, 39, 21823489, ,ahk_pid %pid% ; 오른쪽 키 Lock
postmessage, 0x101, 39, 21823489, ,ahk_pid %pid% ; 오른쪽 키 Release
sleep, 1
}
}
else if(Key="LeftArrow") {
loop, 1 {
postmessage, 0x100, 37, 21692417, ,ahk_pid %pid% ; 오른쪽 키 Lock
postmessage, 0x101, 37, 21692417, ,ahk_pid %pid% ; 오른쪽 키 Release
sleep, 1
}
}
}

NPC거래창전체수리클릭()
{
tempx := mem.read(0x0058EB48, "UInt",0x8C) + 423 - 293
tempy := mem.read(0x0058EB48, "UInt",0x90) + 322 - 173
마우스클릭(tempx,tempy)
}

NPC거래창OK클릭()
{
tempx := mem.read(0x0058EB48, "UInt",0x8C) + 423 - 233
tempy := mem.read(0x0058EB48, "UInt",0x90) + 322 - 173
마우스클릭(tempx,tempy)
}

NPC거래창닫기()
{
tempx := mem.read(0x0058EB48, "UInt",0x8C) + 205 - 233
tempy := mem.read(0x0058EB48, "UInt",0x90) + 57 - 173
마우스오른쪽버튼클릭(tempx,tempy)
}

NPC거래창첫번째메뉴클릭()
{
tempx := mem.read(0x0058EB48, "UInt",0x8C) + 205 - 233
tempy := mem.read(0x0058EB48, "UInt",0x90) + 57 - 173
마우스클릭(tempx,tempy)
}

마우스더블클릭(MouseX,MouseY)
{
PID := TargetPID
if (Multiplyer = "없음" || Multiplyer < 1)
gosub, 일랜시아창크기구하기
MouseX := MouseX * Multiplyer
MouseY := MouseY * Multiplyer
MousePos := MouseX | MouseY << 16
PostMessage, 0x200, 1, %MousePos% ,,ahk_pid %pid%
PostMessage, 0x203, 1, %MousePos% ,,ahk_pid %pid%
PostMessage, 0x202, 0, %MousePos% ,,ahk_pid %pid%
}

마우스오른쪽버튼클릭(MouseX,MouseY)
{
PID := TargetPID
if (Multiplyer = "없음" || Multiplyer < 1)
gosub, 일랜시아창크기구하기
MouseX := MouseX * Multiplyer
MouseY := MouseY * Multiplyer
MousePos := MouseX | MouseY << 16
PostMessage, 0x200, 0, %MousePos% ,,ahk_pid %pid%
PostMessage, 0x204, 1, %MousePos% ,,ahk_pid %pid%
PostMessage, 0x205, 0, %MousePos% ,,ahk_pid %pid%
}

마우스이동(MouseX,MouseY)
{
pid := TargetPid
if (Multiplyer = "없음" || Multiplyer < 1)
gosub, 일랜시아창크기구하기
MouseX := MouseX * Multiplyer
MouseY := MouseY * Multiplyer
MousePos := MouseX | MouseY << 16
PostMessage, 0x200, 0, %MousePos% ,,ahk_pid %pid%
}

메모리권한변경및쓰기(코드)
{
; 변조할 메모리 위치, 크기, 내용 설정
if (코드 = "은행넣기결정코드")  {
Addrs := 0x00590005
RegionSize := 0x200
target = 8B0058DAD4A160808B000001788008408B000000BE32C283D231188D004D840FD2854A3B8304C3830000038BCB8BEF74008B08408B04588B02C083F63108408566FE0166388B0500058DF375FFC08310E6C1005966FE0166388B02F78966F375FF853966D98B10EEC100000110840FFEC361AAEB
executable := mem.executable(Addrs, RegionSize)
}
else if (코드 = "은행넣기실행코드")  {
Addrs := 0x00590185
RegionSize := 0x200
target = 1D89045B8B1B8BE8256A0059054039E859FFF6952DEBB00D8BFFF401C6021940C60058C61B5888001A40001D40C6001C402140C7001F40C62525E80000000174E434C361FFF4C3
executable := mem.executable(Addrs, RegionSize)
}
else if (코드 = "은행빼기코드")  {
Addrs := 0x00590251
RegionSize := 0x200
target =    FFF6946CE8256AC6FFF40078E859001C40C6011B40000000012140C71A40C6021940C640C6001D40C601FFF42469E8001FC3
executable := mem.executable(Addrs, RegionSize)
}
else if (코드 = "하나씩소각코드") {
Addrs := 0x00590097
RegionSize := 0x200
target = 8B0058DAD4A160808B000001788008408B000000BE32C283D231188D004D840FD2854A3B8304C3830000038BCB8BEF74008B08408B04588B02C083F63108408566FE0166388B0147058DF375FFC08310E6C1005966FE0166388B02F78966F375FF853966D98B10EEC100000004840FFE8B1B8BC361AAEB5905401D89045BF695A7E81E6A00FFF41A12E859FF011A40C7195888F425B9E8000000C3D5EBFF
executable := mem.executable(Addrs, RegionSize)
}
else if (코드 = "아이템줍기코드") {
Addrs := 0x005902E5
RegionSize := 0x1400
target = 04EE3005038B600178808B008B000000BE808B000032F88314408B008000000111840F0F00005901E53D3D81000000718474C544005901E500000061840FC704361D89625B8B460500038B00593B83664300590401E51D8DF175004A0500038B00593B8366430059040446158BF1750059044A3D8B00590020840FFA39005904361D8B00000059044605C7004A05C70000000000000000005904C700000093850F0000005904460559044A05C70000EE8300000000007C1D895E5E8B280C4E8B600059048B0059043E0D885904420D88104EF69305E8236A00FFF404D0E859FF19488810244C8A0D8B14244C8B66488966005904421D8B14244C8A1C5889660059043E7089661E48881A488B217889661FC5B9390C6C8104C7402454FF000600000059047C055B5E5F61610000C70010C25DE58B0000005904460559044A05C700005F61000000000010C25DE58B5B5E00000000000000000000000000000000000000000074C54400000000C7740020D15CC70000000000B984000000000000000000000000000000000000000000546E3400000000FFFF000000000000FFFFFFFFFFFF0000000000000000000000000000000000000000000000000000000000
executable := mem.executable(Addrs, RegionSize)
}
else if (코드 = "아이템줍기실행") {
Addrs := 0x00466A99
target = C29000129847E9
줍줍 := TRUE
}
else if (코드 = "아이템줍기정지") {
Addrs := 0x00466A99
target = C25DE58B5B5E5F
줍줍 := False
}
else if (코드 = "무기탈거") {
Addrs := 0x0058D250
RegionSize := 0x100
target = 01BB000000F8B8000000BE000000F6C45EE81E6A00FFF4487BE859FFD5E8FF438DF88B8D194788FFEF7224448D50242444FFED5D55E8501C89661824448B662424448B661A47E8C78B1C478966C3FFF4544A
executable := mem.executable(Addrs, RegionSize)
}
else if (코드 = "타겟스킬사용") {
Addrs := 0x0058FF00
RegionSize := 0x100
target = 00B90058FF20B8F427DCE8000000C3FF
executable := mem.executable(Addrs, RegionSize)
}
else if (코드 = "타겟스킬호출") {
Addrs := 0x0058FF20
RegionSize := 0x50
target = 00003E0054803800000054804400000000000000000201000000
executable := mem.executable(Addrs, RegionSize)
}
else if (코드 = "스킬사용") {
Addrs := 0x0058D600
RegionSize := 0x20
target = DF95E8016A006AC35959FFF2
executable := mem.executable(Addrs, RegionSize)
}
else if (코드 = "MIC") {
Addrs := 0x0058F400
RegionSize := 0x150
target = 2574000004623D0004643D001F0F3D001F0F2E74000F377400000465500C4EB60F001FBF03E93C2474FFB80C4EB60FFFEE74FF5000000469FFEEBEF0E93C240469B80C4EB60F3C2474FF500000B60FFFEEBEDDE900000469B80C4ECAE93C2474FF50FFEEBE
executable := mem.executable(Addrs, RegionSize)
}
else if (코드 = "마법사용") {
Addrs := 0x00590200
RegionSize := 0x100
target = 00B900590220B8F424DCE80000000000000000C3FF
executable := mem.executable(Addrs, RegionSize)
}
else if (코드 = "마법호출") {
Addrs := 0x00590220
RegionSize := 0x50
target = 00000F00548038000000548044000000000000000000010201000000
executable := mem.executable(Addrs, RegionSize)
}
else if (코드 = "좌표이동") {
Addrs := 0x00590600
RegionSize := 0x200
target = 000000000000000000000000010000000000000000000000000000003D836000000000840F0000590600DAD4A100000084F8830C408B005800000073840F0200005906B93D838D0000000B850FB9A300590600055906B9A10059060F04488B188B0058DAD4A153D9AF14488B10588B000FD83958D9AF0F05830000002085B9A110005906B90F003883005906058D0000000B8506B9A3005906005906B9058D0059DAD41D8B008B00EFE850016A00580C4D8B61FFF3A200590600C3C129590600
executable := mem.executable(Addrs, RegionSize)
}
else if (코드 = "정령석합치기") {
Addrs := 0x00590220
RegionSize := 0x50
target = 00006B005300A200000053C3A40000000000000000
아이템번호 := Format("{:02x}", 합칠아이템순서)
숫자만 := RegExReplace(아이템번호, "0x")
target .= 숫자만
target .= 01010100000014
executable := mem.executable(Addrs, RegionSize)
}
else if (코드 = "공격하기") {
Addrs := 0x00590700
RegionSize := 0x100
target = 0D8B00000001B80002BA0059073058DAD4358B0000F3A3B0E8515000C3FF
executable := mem.executable(Addrs, RegionSize)
}
else if (코드 = "따라가기") {
Addrs := 0x00590740
RegionSize := 0x100
target = 0D8B00000001B80000BA0059077058DAD4358B0000F3A3C1E8515000C3FF
executable := mem.executable(Addrs, RegionSize)
}
else if (코드 = "몬스터주소기록켜기") {
Addrs := 0x0048E1EB
target = 1024001025A0E9
}
else if (코드 = "몬스터주소기록끄기") {
Addrs := 0x0048E1EB
target = 10245489CB3966
}
else if (코드 = "몬스터주소기록함수") {
Addrs := 0x00590790
RegionSize := 0x200
target = 89005907D0A160005907D0058130D03D810000000400590800005907C700401F0F0E7507D4005907D00500000001B80059245489CB39666100FFEFDA24E910
executable := mem.executable(Addrs, RegionSize)
mem.write(0x005907D0,0x005907D4,"uint",aOffsets*)
}
else if (코드 = "아이템주소기록켜기") {
Addrs := 0x0047B3D2
target =
}
else if (코드 = "아이템주소기록끄기") {
Addrs := 0x0047B3D2
target =
}
else if (코드 = "아이템주소기록함수") {
Addrs := 0x00590850
RegionSize := 0x250
target =
;몬스터 ~590800 아이템 ~590900 플레이어~590B80
executable := mem.executable(Addrs, RegionSize)
mem.write(0x005908A0,0x005908A4,"uint",aOffsets*)
}
else if (코드 = "플레이주소기록켜기") {
Addrs := 0x004602B0
target = 00C20013084BE9
}
else if (코드 = "플레이주소기록끄기") {
Addrs := 0x004602B0
target = C0852C24448959
}
else if (코드 = "플레이주소기록함수") {
Addrs := 0x00590B00
RegionSize := 0x200
target = 308900590B40A10400590B4005810B403D810000007500590B80005905C700401F0F0E590B4400590B400446C756C68B00F77EE90053E3F0C3FFEC
executable := mem.executable(Addrs, RegionSize)
mem.write(0x00590B40,0x00590B44,"uint",aOffsets*)
}
else if (코드 = "파티걸기") { ;set_party_memory()
Addrs := 0x0058FE00
RegionSize := 0x200
target = FFF698BDE81F6AC6FFF419D0E859FE200D8B011940CCE81A48890058C3FFF428
executable := mem.executable(Addrs, RegionSize)
}
else if (코드 = "NPC호출용1") { ;set_NPC_memory()
Addrs := 0x00527ACC
RegionSize := 0x200
target = 00004300547E10000000547E1C00000000000000000000010100000000000000
executable := mem.executable(Addrs, RegionSize)
}
else if (코드 = "NPC호출용2") { ;set_NPC_memory2()
Addrs := 0x00527B4C
target = 40C700527ACCB88EE8000000001A000000C3FFFAAB0000000000000000000000
}
else if (코드 = "퀵슬롯사용") {
Addrs := 0x005279CC
RegionSize := 0x20
target = 0058DAD4BF016AC3FFF8C398E8
executable := mem.executable(Addrs, RegionSize)
}
else if (코드 = "기존지침서무시") {
Addrs := 0x00438CEE
target = 906600157D0DE9
}
else if (코드 = "기존지침서사용") {
Addrs := 0x00438CEE
target = E8458D5056008B
}

;Below is a generated code via python.

else if (코드 = "요리지침서 1-1 달걀 요리(Lv1)") {
Addrs := 0x00590A00
RegionSize := 0x2048
target = 1A2D00590A2EB86850E8D100590AE8458D00590A1AB2ECFFEA82DBE9ACC6940020AC400076004C0028B90000000029003100000000
executable := mem.executable(Addrs, RegionSize)
SB_SetText(" 요리지침서 1-1 달걀 요리(Lv1) 쓰기", 1)
}
else if (코드 = "요리지침서 1-2 식빵 요리(Lv1)") {
Addrs := 0x00590A00
RegionSize := 0x2048
target = 1A2D00590A2EB86850E8D100590AE8458D00590A1AC2DDFFEA82DBE9ACC6940020BE750076004C0028B90000000029003100000000
executable := mem.executable(Addrs, RegionSize)
SB_SetText(" 요리지침서 1-2 식빵 요리(Lv1) 쓰기", 1)
}
else if (코드 = "요리지침서 1-3 스프 요리(Lv1)") {
Addrs := 0x00590A00
RegionSize := 0x2048
target = 1A2D00590A2EB86850E8D100590AE8458D00590A1AC2A4FFEA82DBE9ACC6940020D5040076004C0028B90000000029003100000000
executable := mem.executable(Addrs, RegionSize)
SB_SetText(" 요리지침서 1-3 스프 요리(Lv1) 쓰기", 1)
}
else if (코드 = "요리지침서 1-4 샌드위치 요리(Lv1)") {
Addrs := 0x00590A00
RegionSize := 0x2048
target = 1A2D00590A32B86850E8D100590AE8458D00590A1AC0CCFFEA82DBE920CE58C704B4DC0028B9ACC694002900310076004C0000000000000000
executable := mem.executable(Addrs, RegionSize)
SB_SetText(" 요리지침서 1-4 샌드위치 요리(Lv1) 쓰기", 1)
}
else if (코드 = "요리지침서 1-5 초컬릿(Lv1)") {
Addrs := 0x00590A00
RegionSize := 0x2048
target = 1A2D00590A2AB86850E8D100590AE8458D00590A1ACD08FFEA82DBE94C0028B9BFCEEC0029003100760000000000000000
executable := mem.executable(Addrs, RegionSize)
SB_SetText(" 요리지침서 1-5 초컬릿(Lv1) 쓰기", 1)
}
else if (코드 = "요리지침서 1-6 송편(Lv1)") {
Addrs := 0x00590A00
RegionSize := 0x2048
target = 1A2D00590A28B86850E8D100590AE8458D00590A1AC1A1FFEA82DBE976004C0028D3B8000000290031000000000000
executable := mem.executable(Addrs, RegionSize)
SB_SetText(" 요리지침서 1-6 송편(Lv1) 쓰기", 1)
}
else if (코드 = "요리지침서 2-1 주먹밥 요리(Lv2)") {
Addrs := 0x00590A00
RegionSize := 0x2048
target = 1A2D00590A30B86850E8D100590AE8458D00590A1AC8FCFFEA82DBE9940020BC25BA39004C0028B9ACC600002900320076000000000000
executable := mem.executable(Addrs, RegionSize)
SB_SetText(" 요리지침서 2-1 주먹밥 요리(Lv2) 쓰기", 1)
}
else if (코드 = "요리지침서 2-2 오믈렛 요리(Lv2)") {
Addrs := 0x00590A00
RegionSize := 0x2048
target = 1A2D00590A30B86850E8D100590AE8458D00590A1AC624FFEA82DBE9940020B81BBBC8004C0028B9ACC600002900320076000000000000
executable := mem.executable(Addrs, RegionSize)
SB_SetText(" 요리지침서 2-2 오믈렛 요리(Lv2) 쓰기", 1)
}
else if (코드 = "요리지침서 2-3 파이 요리(Lv2)") {
Addrs := 0x00590A00
RegionSize := 0x2048
target = 1A2D00590A2EB86850E8D100590AE8458D00590A1AD30CFFEA82DBE9ACC6940020C7740076004C0028B90000000029003200000000
executable := mem.executable(Addrs, RegionSize)
SB_SetText(" 요리지침서 2-3 파이 요리(Lv2) 쓰기", 1)
}
else if (코드 = "요리지침서 2-4 케익 요리(Lv2)") {
Addrs := 0x00590A00
RegionSize := 0x2048
target = 1A2D00590A2EB86850E8D100590AE8458D00590A1ACF00FFEA82DBE9ACC6940020C7750076004C0028B90000000029003200000000
executable := mem.executable(Addrs, RegionSize)
SB_SetText(" 요리지침서 2-4 케익 요리(Lv2) 쓰기", 1)
}
else if (코드 = "요리지침서 2-5 쥬스 요리(Lv2)") {
Addrs := 0x00590A00
RegionSize := 0x2048
target = 1A2D00590A2EB86850E8D100590AE8458D00590A1AC96CFFEA82DBE9ACC6940020C2A40076004C0028B90000000029003200000000
executable := mem.executable(Addrs, RegionSize)
SB_SetText(" 요리지침서 2-5 쥬스 요리(Lv2) 쓰기", 1)
}
else if (코드 = "요리지침서 3-1 카레 요리(Lv3)") {
Addrs := 0x00590A00
RegionSize := 0x2048
target = 1A2D00590A2EB86850E8D100590AE8458D00590A1ACE74FFEA82DBE9ACC6940020B8080076004C0028B90000000029003300000000
executable := mem.executable(Addrs, RegionSize)
SB_SetText(" 요리지침서 3-1 카레 요리(Lv3) 쓰기", 1)
}
else if (코드 = "요리지침서 3-2 마늘 요리(Lv3)") {
Addrs := 0x00590A00
RegionSize := 0x2048
target = 1A2D00590A2EB86850E8D100590AE8458D00590A1AB9C8FFEA82DBE9ACC6940020B2980076004C0028B90000000029003300000000
executable := mem.executable(Addrs, RegionSize)
SB_SetText(" 요리지침서 3-2 마늘 요리(Lv3) 쓰기", 1)
}
else if (코드 = "요리지침서 4-1 비스킷 요리(Lv4)") {
Addrs := 0x00590A00
RegionSize := 0x2048
target = 1A2D00590A30B86850E8D100590AE8458D00590A1ABE44FFEA82DBE9940020D0B7C2A4004C0028B9ACC600002900340076000000000000
executable := mem.executable(Addrs, RegionSize)
SB_SetText(" 요리지침서 4-1 비스킷 요리(Lv4) 쓰기", 1)
}
else if (코드 = "요리지침서 4-2 닭고기 요리(Lv4)") {
Addrs := 0x00590A00
RegionSize := 0x2048
target = 1A2D00590A30B86850E8D100590AE8458D00590A1AB2EDFFEA82DBE9940020AE30ACE0004C0028B9ACC600002900340076000000000000
executable := mem.executable(Addrs, RegionSize)
SB_SetText(" 요리지침서 4-2 닭고기 요리(Lv4) 쓰기", 1)
}
else if (코드 = "요리지침서 4-3 돼지고기 요리(Lv4)") {
Addrs := 0x00590A00
RegionSize := 0x2048
target = 1A2D00590A32B86850E8D100590AE8458D00590A1AB3FCFFEA82DBE920AE30ACE0C9C00028B9ACC694002900340076004C0000000000000000
executable := mem.executable(Addrs, RegionSize)
SB_SetText(" 요리지침서 4-3 돼지고기 요리(Lv4) 쓰기", 1)
}
else if (코드 = "요리지침서 4-4 생선 요리(Lv4)") {
Addrs := 0x00590A00
RegionSize := 0x2048
target = 1A2D00590A2EB86850E8D100590AE8458D00590A1AC0DDFFEA82DBE9ACC6940020C1200076004C0028B90000000029003400000000
executable := mem.executable(Addrs, RegionSize)
SB_SetText(" 요리지침서 4-4 생선 요리(Lv4) 쓰기", 1)
}
else if (코드 = "요리지침서 4-5 초밥 요리(Lv4)") {
Addrs := 0x00590A00
RegionSize := 0x2048
target = 1A2D00590A2EB86850E8D100590AE8458D00590A1ACD08FFEA82DBE9ACC6940020BC250076004C0028B90000000029003400000000
executable := mem.executable(Addrs, RegionSize)
SB_SetText(" 요리지침서 4-5 초밥 요리(Lv4) 쓰기", 1)
}
else if (코드 = "요리지침서 5-1 팥빙수 요리(Lv5)") {
Addrs := 0x00590A00
RegionSize := 0x2048
target = 1A2D00590A30B86850E8D100590AE8458D00590A1AD325FFEA82DBE9940020C218BE59004C0028B9ACC600002900350076000000000000
executable := mem.executable(Addrs, RegionSize)
SB_SetText(" 요리지침서 5-1 팥빙수 요리(Lv5) 쓰기", 1)
}
else if (코드 = "요리지침서 5-2 스파게티 요리(Lv5)") {
Addrs := 0x00590A00
RegionSize := 0x2048
target = 1A2D00590A32B86850E8D100590AE8458D00590A1AC2A4FFEA82DBE920D2F0AC8CD30C0028B9ACC694002900350076004C0000000000000000
executable := mem.executable(Addrs, RegionSize)
SB_SetText(" 요리지침서 5-2 스파게티 요리(Lv5) 쓰기", 1)
}
else if (코드 = "요리지침서 5-3 김치 요리(Lv5)") {
Addrs := 0x00590A00
RegionSize := 0x2048
target = 1A2D00590A2EB86850E8D100590AE8458D00590A1AAE40FFEA82DBE9ACC6940020CE580076004C0028B90000000029003500000000
executable := mem.executable(Addrs, RegionSize)
SB_SetText(" 요리지침서 5-3 김치 요리(Lv5) 쓰기", 1)
}
else if (코드 = "요리지침서 5-4 볶음밥 요리(Lv5)") {
Addrs := 0x00590A00
RegionSize := 0x2048
target = 1A2D00590A30B86850E8D100590AE8458D00590A1ABCF6FFEA82DBE9940020BC25C74C004C0028B9ACC600002900350076000000000000
executable := mem.executable(Addrs, RegionSize)
SB_SetText(" 요리지침서 5-4 볶음밥 요리(Lv5) 쓰기", 1)
}
else if (코드 = "스미스지침서 1-1 툴 수리(Lv1)") {
Addrs := 0x00590A00
RegionSize := 0x2048
target = 1A2D00590A2CB86850E8D100590AE8458D00590A1AD234FFEA82DBE928B9ACC218002000310076004C00000000000000290000
executable := mem.executable(Addrs, RegionSize)
SB_SetText(" 스미스지침서 1-1 툴 수리(Lv1) 쓰기", 1)
}
else if (코드 = "스미스지침서 1-2 검 수리(Lv1)") {
Addrs := 0x00590A00
RegionSize := 0x2048
target = 1A2D00590A2CB86850E8D100590AE8458D00590A1AAC80FFEA82DBE928B9ACC218002000310076004C00000000000000290000
executable := mem.executable(Addrs, RegionSize)
SB_SetText(" 스미스지침서 1-2 검 수리(Lv1) 쓰기", 1)
}
else if (코드 = "스미스지침서 1-3 창 수리(Lv1)") {
Addrs := 0x00590A00
RegionSize := 0x2048
target = 1A2D00590A2CB86850E8D100590AE8458D00590A1ACC3DFFEA82DBE928B9ACC218002000310076004C00000000000000290000
executable := mem.executable(Addrs, RegionSize)
SB_SetText(" 스미스지침서 1-3 창 수리(Lv1) 쓰기", 1)
}
else if (코드 = "스미스지침서 1-4 기타 수리(Lv1)") {
Addrs := 0x00590A00
RegionSize := 0x2048
target = 1A2D00590A2EB86850E8D100590AE8458D00590A1AAE30FFEA82DBE9ACC2180020D0C00076004C0028B90000000029003100000000
executable := mem.executable(Addrs, RegionSize)
SB_SetText(" 스미스지침서 1-4 기타 수리(Lv1) 쓰기", 1)
}
else if (코드 = "스미스지침서 2-1 낚시대 제작(Lv2)") {
Addrs := 0x00590A00
RegionSize := 0x2048
target = 1A2D00590A30B86850E8D100590AE8458D00590A1AB09AFFEA82DBE91C0020B300C2DC004C0028C791C800002900320076000000000000
executable := mem.executable(Addrs, RegionSize)
SB_SetText(" 스미스지침서 2-1 낚시대 제작(Lv2) 쓰기", 1)
}
else if (코드 = "스미스지침서 2-2 픽액스 제작(Lv2)") {
Addrs := 0x00590A00
RegionSize := 0x2048
target = 1A2D00590A30B86850E8D100590AE8458D00590A1AD53DFFEA82DBE91C0020C2A4C561004C0028C791C800002900320076000000000000
executable := mem.executable(Addrs, RegionSize)
SB_SetText(" 스미스지침서 2-2 픽액스 제작(Lv2) 쓰기", 1)
}
else if (코드 = "스미스지침서 2-3 요리키트 제작(Lv2)") {
Addrs := 0x00590A00
RegionSize := 0x2048
target = 1A2D00590A32B86850E8D100590AE8458D00590A1AC694FFEA82DBE920D2B8D0A4B9AC0028C791C81C002900320076004C0000000000000000
executable := mem.executable(Addrs, RegionSize)
SB_SetText(" 스미스지침서 2-3 요리키트 제작(Lv2) 쓰기", 1)
}
else if (코드 = "스미스지침서 2-4 미리온스캐너 제작(Lv2)") {
Addrs := 0x00590A00
RegionSize := 0x2048
target = 1A2D00590A36B86850E8D100590AE8458D00590A1ABBF8FFEA82DBE990C2A4C628B9ACC81C0020B108CE76004C0028C791000000290032000000000000
executable := mem.executable(Addrs, RegionSize)
SB_SetText(" 스미스지침서 2-4 미리온스캐너 제작(Lv2) 쓰기", 1)
}
else if (코드 = "스미스지침서 2-5 스미스키트 제작(Lv2)") {
Addrs := 0x00590A00
RegionSize := 0x2048
target = 1A2D00590A34B86850E8D100590AE8458D00590A1AC2A4FFEA82DBE9B8D0A4C2A4BBF8C791C81C0020D2320076004C002800000000002900000000
executable := mem.executable(Addrs, RegionSize)
SB_SetText(" 스미스지침서 2-5 스미스키트 제작(Lv2) 쓰기", 1)
}
else if (코드 = "스미스지침서 2-6 재단키트 제작(Lv2)") {
Addrs := 0x00590A00
RegionSize := 0x2048
target = 1A2D00590A32B86850E8D100590AE8458D00590A1AC7ACFFEA82DBE920D2B8D0A4B2E80028C791C81C002900320076004C0000000000000000
executable := mem.executable(Addrs, RegionSize)
SB_SetText(" 스미스지침서 2-6 재단키트 제작(Lv2) 쓰기", 1)
}
else if (코드 = "스미스지침서 2-7 세공키트 제작(Lv2)") {
Addrs := 0x00590A00
RegionSize := 0x2048
target = 1A2D00590A32B86850E8D100590AE8458D00590A1AC138FFEA82DBE920D2B8D0A4ACF50028C791C81C002900320076004C0000000000000000
executable := mem.executable(Addrs, RegionSize)
SB_SetText(" 스미스지침서 2-7 세공키트 제작(Lv2) 쓰기", 1)
}
else if (코드 = "스미스지침서 2-8 관측키트 제작(Lv2)") {
Addrs := 0x00590A00
RegionSize := 0x2048
target = 1A2D00590A32B86850E8D100590AE8458D00590A1AAD00FFEA82DBE920D2B8D0A4CE210028C791C81C002900320076004C0000000000000000
executable := mem.executable(Addrs, RegionSize)
SB_SetText(" 스미스지침서 2-8 관측키트 제작(Lv2) 쓰기", 1)
}
else if (코드 = "스미스지침서 3-1 롱소드 제작(Lv3)") {
Addrs := 0x00590A00
RegionSize := 0x2048
target = 1A2D00590A30B86850E8D100590AE8458D00590A1AB871FFEA82DBE91C0020B4DCC18C004C0028C791C800002900330076000000000000
executable := mem.executable(Addrs, RegionSize)
SB_SetText(" 스미스지침서 3-1 롱소드 제작(Lv3) 쓰기", 1)
}
else if (코드 = "스미스지침서 3-2 바스타드소드 제작(Lv3)") {
Addrs := 0x00590A00
RegionSize := 0x2048
target = 1A2D00590A36B86850E8D100590AE8458D00590A1ABC14FFEA82DBE98CB4DCD0C0C2A4C81C0020B4DCC176004C0028C791000000290033000000000000
executable := mem.executable(Addrs, RegionSize)
SB_SetText(" 스미스지침서 3-2 바스타드소드 제작(Lv3) 쓰기", 1)
}
else if (코드 = "스미스지침서 3-3 그레이트소드 제작(Lv3)") {
Addrs := 0x00590A00
RegionSize := 0x2048
target = 1A2D00590A36B86850E8D100590AE8458D00590A1AADF8FFEA82DBE98CD2B8C774B808C81C0020B4DCC176004C0028C791000000290033000000000000
executable := mem.executable(Addrs, RegionSize)
SB_SetText(" 스미스지침서 3-3 그레이트소드 제작(Lv3) 쓰기", 1)
}
else if (코드 = "스미스지침서 3-4 대거 제작(Lv3)") {
Addrs := 0x00590A00
RegionSize := 0x2048
target = 1A2D00590A2EB86850E8D100590AE8458D00590A1AB300FFEA82DBE991C81C0020AC700076004C0028C70000000029003300000000
executable := mem.executable(Addrs, RegionSize)
SB_SetText(" 스미스지침서 3-4 대거 제작(Lv3) 쓰기", 1)
}
else if (코드 = "스미스지침서 3-5 고태도 제작(Lv3)") {
Addrs := 0x00590A00
RegionSize := 0x2048
target = 1A2D00590A30B86850E8D100590AE8458D00590A1AACE0FFEA82DBE91C0020B3C4D0DC004C0028C791C800002900330076000000000000
executable := mem.executable(Addrs, RegionSize)
SB_SetText(" 스미스지침서 3-5 고태도 제작(Lv3) 쓰기", 1)
}
else if (코드 = "스미스지침서 3-6 롱스피어 제작(Lv3)") {
Addrs := 0x00590A00
RegionSize := 0x2048
target = 1A2D00590A32B86850E8D100590AE8458D00590A1AB871FFEA82DBE920C5B4D53CC2A40028C791C81C002900330076004C0000000000000000
executable := mem.executable(Addrs, RegionSize)
SB_SetText(" 스미스지침서 3-6 롱스피어 제작(Lv3) 쓰기", 1)
}
else if (코드 = "스미스지침서 3-7 반월도 제작(Lv3)") {
Addrs := 0x00590A00
RegionSize := 0x2048
target = 1A2D00590A30B86850E8D100590AE8458D00590A1ABC18FFEA82DBE91C0020B3C4C6D4004C0028C791C800002900330076000000000000
executable := mem.executable(Addrs, RegionSize)
SB_SetText(" 스미스지침서 3-7 반월도 제작(Lv3) 쓰기", 1)
}
else if (코드 = "스미스지침서 3-8 액스 제작(Lv3)") {
Addrs := 0x00590A00
RegionSize := 0x2048
target = 1A2D00590A2EB86850E8D100590AE8458D00590A1AC561FFEA82DBE991C81C0020C2A40076004C0028C70000000029003300000000
executable := mem.executable(Addrs, RegionSize)
SB_SetText(" 스미스지침서 3-8 액스 제작(Lv3) 쓰기", 1)
}
else if (코드 = "스미스지침서 3-9 햄머 제작(Lv3)") {
Addrs := 0x00590A00
RegionSize := 0x2048
target = 1A2D00590A2EB86850E8D100590AE8458D00590A1AD584FFEA82DBE991C81C0020BA380076004C0028C70000000029003300000000
executable := mem.executable(Addrs, RegionSize)
SB_SetText(" 스미스지침서 3-9 햄머 제작(Lv3) 쓰기", 1)
}
else if (코드 = "스미스지침서 3-10 우든보우 제작(Lv3)") {
Addrs := 0x00590A00
RegionSize := 0x2048
target = 1A2D00590A32B86850E8D100590AE8458D00590A1AC6B0FFEA82DBE920C6B0BCF4B4E00028C791C81C002900330076004C0000000000000000
executable := mem.executable(Addrs, RegionSize)
SB_SetText(" 스미스지침서 3-10 우든보우 제작(Lv3) 쓰기", 1)
}
else if (코드 = "스미스지침서 3-11 우든하프 제작(Lv3)") {
Addrs := 0x00590A00
RegionSize := 0x2048
target = 1A2D00590A32B86850E8D100590AE8458D00590A1AC6B0FFEA82DBE920D504D558B4E00028C791C81C002900330076004C0000000000000000
executable := mem.executable(Addrs, RegionSize)
SB_SetText(" 스미스지침서 3-11 우든하프 제작(Lv3) 쓰기", 1)
}
else if (코드 = "스미스지침서 3-12 시미터 제작(Lv3)") {
Addrs := 0x00590A00
RegionSize := 0x2048
target = 1A2D00590A30B86850E8D100590AE8458D00590A1AC2DCFFEA82DBE91C0020D130BBF8004C0028C791C800002900330076000000000000
executable := mem.executable(Addrs, RegionSize)
SB_SetText(" 스미스지침서 3-12 시미터 제작(Lv3) 쓰기", 1)
}
else if (코드 = "스미스지침서 4-1 아이언아머 제작(Lv4)") {
Addrs := 0x00590A00
RegionSize := 0x2048
target = 1A2D00590A34B86850E8D100590AE8458D00590A1AC544FFEA82DBE938C544C5B8C774C791C81C0020BA340076004C002800000000002900000000
executable := mem.executable(Addrs, RegionSize)
SB_SetText(" 스미스지침서 4-1 아이언아머 제작(Lv4) 쓰기", 1)
}
else if (코드 = "스미스지침서 4-2 폴드아머 제작(Lv4)") {
Addrs := 0x00590A00
RegionSize := 0x2048
target = 1A2D00590A32B86850E8D100590AE8458D00590A1AD3F4FFEA82DBE920BA38C544B4DC0028C791C81C002900340076004C0000000000000000
executable := mem.executable(Addrs, RegionSize)
SB_SetText(" 스미스지침서 4-2 폴드아머 제작(Lv4) 쓰기", 1)
}
else if (코드 = "스미스지침서 4-3 스탠다드 아머 제작(Lv4)") {
Addrs := 0x00590A00
RegionSize := 0x2048
target = 1A2D00590A38B86850E8D100590AE8458D00590A1AC2A4FFEA82DBE920B4DCB2E4D0E00020BA38C544004C0028C791C81C0029003400760000000000000000
executable := mem.executable(Addrs, RegionSize)
SB_SetText(" 스미스지침서 4-3 스탠다드 아머 제작(Lv4) 쓰기", 1)
}
else if (코드 = "스미스지침서 4-4 터틀아머 제작(Lv4)") {
Addrs := 0x00590A00
RegionSize := 0x2048
target = 1A2D00590A32B86850E8D100590AE8458D00590A1AD130FFEA82DBE920BA38C544D2C00028C791C81C002900340076004C0000000000000000
executable := mem.executable(Addrs, RegionSize)
SB_SetText(" 스미스지침서 4-4 터틀아머 제작(Lv4) 쓰기", 1)
}
else if (코드 = "스미스지침서 4-5 트로져아머 제작(Lv4)") {
Addrs := 0x00590A00
RegionSize := 0x2048
target = 1A2D00590A34B86850E8D100590AE8458D00590A1AD2B8FFEA82DBE938C544C838B85CC791C81C0020BA340076004C002800000000002900000000
executable := mem.executable(Addrs, RegionSize)
SB_SetText(" 스미스지침서 4-5 트로져아머 제작(Lv4) 쓰기", 1)
}
else if (코드 = "스미스지침서 4-6 숄드레더 아머 제작(Lv4)") {
Addrs := 0x00590A00
RegionSize := 0x2048
target = 1A2D00590A38B86850E8D100590AE8458D00590A1AC204FFEA82DBE920B354B808B4DC0020BA38C544004C0028C791C81C0029003400760000000000000000
executable := mem.executable(Addrs, RegionSize)
SB_SetText(" 스미스지침서 4-6 숄드레더 아머 제작(Lv4) 쓰기", 1)
}
else if (코드 = "스미스지침서 4-7 밴디드레더 아머 제작(Lv4)") {
Addrs := 0x00590A00
RegionSize := 0x2048
target = 1A2D00590A3AB86850E8D100590AE8458D00590A1ABC34FFEA82DBE954B808B4DCB514BA38C5440020B328C791C81C002000340076004C00000000000000290000
executable := mem.executable(Addrs, RegionSize)
SB_SetText(" 스미스지침서 4-7 밴디드레더 아머 제작(Lv4) 쓰기", 1)
}
else if (코드 = "스미스지침서 4-8 밴디드아이언 아머 제작(Lv4)") {
Addrs := 0x00590A00
RegionSize := 0x2048
target = 1A2D00590A3CB86850E8D100590AE8458D00590A1ABC34FFEA82DBE974C544B4DCB514C5440020C5B8C791C81C0020BA380076004C0028C70000000029003400000000
executable := mem.executable(Addrs, RegionSize)
SB_SetText(" 스미스지침서 4-8 밴디드아이언 아머 제작(Lv4) 쓰기", 1)
}
else if (코드 = "스미스지침서 4-9 밴디드실버 아머 제작(Lv4)") {
Addrs := 0x00590A00
RegionSize := 0x2048
target = 1A2D00590A3AB86850E8D100590AE8458D00590A1ABC34FFEA82DBE984C2E4B4DCB514BA38C5440020BC28C791C81C002000340076004C00000000000000290000
executable := mem.executable(Addrs, RegionSize)
SB_SetText(" 스미스지침서 4-9 밴디드실버 아머 제작(Lv4) 쓰기", 1)
}
else if (코드 = "스미스지침서 4-10 밴디드골드 아머 제작(Lv4)") {
Addrs := 0x00590A00
RegionSize := 0x2048
target = 1A2D00590A3AB86850E8D100590AE8458D00590A1ABC34FFEA82DBE9DCACE8B4DCB514BA38C5440020B428C791C81C002000340076004C00000000000000290000
executable := mem.executable(Addrs, RegionSize)
SB_SetText(" 스미스지침서 4-10 밴디드골드 아머 제작(Lv4) 쓰기", 1)
}
else if (코드 = "스미스지침서 5-1 우든실드 제작(Lv5)") {
Addrs := 0x00590A00
RegionSize := 0x2048
target = 1A2D00590A32B86850E8D100590AE8458D00590A1AC6B0FFEA82DBE920B4DCC2E4B4E00028C791C81C002900350076004C0000000000000000
executable := mem.executable(Addrs, RegionSize)
SB_SetText(" 스미스지침서 5-1 우든실드 제작(Lv5) 쓰기", 1)
}
else if (코드 = "스미스지침서 5-2 실드 제작(Lv5)") {
Addrs := 0x00590A00
RegionSize := 0x2048
target = 1A2D00590A2EB86850E8D100590AE8458D00590A1AC2E4FFEA82DBE991C81C0020B4DC0076004C0028C70000000029003500000000
executable := mem.executable(Addrs, RegionSize)
SB_SetText(" 스미스지침서 5-2 실드 제작(Lv5) 쓰기", 1)
}
else if (코드 = "스미스지침서 5-3 아이언실드 제작(Lv5)") {
Addrs := 0x00590A00
RegionSize := 0x2048
target = 1A2D00590A34B86850E8D100590AE8458D00590A1AC544FFEA82DBE9DCC2E4C5B8C774C791C81C0020B4350076004C002800000000002900000000
executable := mem.executable(Addrs, RegionSize)
SB_SetText(" 스미스지침서 5-3 아이언실드 제작(Lv5) 쓰기", 1)
}
else if (코드 = "스미스지침서 5-4 스톤실드 제작(Lv5)") {
Addrs := 0x00590A00
RegionSize := 0x2048
target = 1A2D00590A32B86850E8D100590AE8458D00590A1AC2A4FFEA82DBE920B4DCC2E4D1A40028C791C81C002900350076004C0000000000000000
executable := mem.executable(Addrs, RegionSize)
SB_SetText(" 스미스지침서 5-4 스톤실드 제작(Lv5) 쓰기", 1)
}
else if (코드 = "스미스지침서 5-5 골든실드 제작(Lv5)") {
Addrs := 0x00590A00
RegionSize := 0x2048
target = 1A2D00590A32B86850E8D100590AE8458D00590A1AACE8FFEA82DBE920B4DCC2E4B4E00028C791C81C002900350076004C0000000000000000
executable := mem.executable(Addrs, RegionSize)
SB_SetText(" 스미스지침서 5-5 골든실드 제작(Lv5) 쓰기", 1)
}
else if (코드 = "스미스지침서 6-1 올드헬멧 제작(Lv6)") {
Addrs := 0x00590A00
RegionSize := 0x2048
target = 1A2D00590A32B86850E8D100590AE8458D00590A1AC62CFFEA82DBE920BA67D5ECB4DC0028C791C81C002900360076004C0000000000000000
executable := mem.executable(Addrs, RegionSize)
SB_SetText(" 스미스지침서 6-1 올드헬멧 제작(Lv6) 쓰기", 1)
}
else if (코드 = "재단지침서 1-1 반바지 수선(Lv1)") {
Addrs := 0x00590A00
RegionSize := 0x2048
target = 1A2D00590A30B86850E8D100590AE8458D00590A1ABC18FFEA82DBE9180020C9C0BC14004C0028C120C200002900310076000000000000
executable := mem.executable(Addrs, RegionSize)
SB_SetText(" 재단지침서 1-1 반바지 수선(Lv1) 쓰기", 1)
}
else if (코드 = "재단지침서 1-2 바지 수선(Lv1)") {
Addrs := 0x00590A00
RegionSize := 0x2048
target = 1A2D00590A2EB86850E8D100590AE8458D00590A1ABC14FFEA82DBE920C2180020C9C00076004C0028C10000000029003100000000
executable := mem.executable(Addrs, RegionSize)
SB_SetText(" 재단지침서 1-2 바지 수선(Lv1) 쓰기", 1)
}
else if (코드 = "재단지침서 1-3 튜닉 수선(Lv1)") {
Addrs := 0x00590A00
RegionSize := 0x2048
target = 1A2D00590A2EB86850E8D100590AE8458D00590A1AD29CFFEA82DBE920C2180020B2C90076004C0028C10000000029003100000000
executable := mem.executable(Addrs, RegionSize)
SB_SetText(" 재단지침서 1-3 튜닉 수선(Lv1) 쓰기", 1)
}
else if (코드 = "재단지침서 1-4 가니쉬 수선(Lv1)") {
Addrs := 0x00590A00
RegionSize := 0x2048
target = 1A2D00590A30B86850E8D100590AE8458D00590A1AAC00FFEA82DBE9180020C26CB2C8004C0028C120C200002900310076000000000000
executable := mem.executable(Addrs, RegionSize)
SB_SetText(" 재단지침서 1-4 가니쉬 수선(Lv1) 쓰기", 1)
}
else if (코드 = "재단지침서 1-5 레더슈즈 수선(Lv1)") {
Addrs := 0x00590A00
RegionSize := 0x2048
target = 1A2D00590A32B86850E8D100590AE8458D00590A1AB808FFEA82DBE920C988C288B3540028C120C218002900310076004C0000000000000000
executable := mem.executable(Addrs, RegionSize)
SB_SetText(" 재단지침서 1-5 레더슈즈 수선(Lv1) 쓰기", 1)
}
else if (코드 = "재단지침서 1-6 레더아머 수선(Lv1)") {
Addrs := 0x00590A00
RegionSize := 0x2048
target = 1A2D00590A32B86850E8D100590AE8458D00590A1AB808FFEA82DBE920BA38C544B3540028C120C218002900310076004C0000000000000000
executable := mem.executable(Addrs, RegionSize)
SB_SetText(" 재단지침서 1-6 레더아머 수선(Lv1) 쓰기", 1)
}
else if (코드 = "재단지침서 2-1 반바지 제작(Lv2)") {
Addrs := 0x00590A00
RegionSize := 0x2048
target = 1A2D00590A30B86850E8D100590AE8458D00590A1ABC18FFEA82DBE91C0020C9C0BC14004C0028C791C800002900320076000000000000
executable := mem.executable(Addrs, RegionSize)
SB_SetText(" 재단지침서 2-1 반바지 제작(Lv2) 쓰기", 1)
}
else if (코드 = "재단지침서 2-2 바지 제작(Lv2)") {
Addrs := 0x00590A00
RegionSize := 0x2048
target = 1A2D00590A2EB86850E8D100590AE8458D00590A1ABC14FFEA82DBE991C81C0020C9C00076004C0028C70000000029003200000000
executable := mem.executable(Addrs, RegionSize)
SB_SetText(" 재단지침서 2-2 바지 제작(Lv2) 쓰기", 1)
}
else if (코드 = "재단지침서 2-3 튜닉 제작(Lv2)") {
Addrs := 0x00590A00
RegionSize := 0x2048
target = 1A2D00590A2EB86850E8D100590AE8458D00590A1AD29CFFEA82DBE991C81C0020B2C90076004C0028C70000000029003200000000
executable := mem.executable(Addrs, RegionSize)
SB_SetText(" 재단지침서 2-3 튜닉 제작(Lv2) 쓰기", 1)
}
else if (코드 = "재단지침서 2-4 가니쉬 제작(Lv2)") {
Addrs := 0x00590A00
RegionSize := 0x2048
target = 1A2D00590A30B86850E8D100590AE8458D00590A1AAC00FFEA82DBE91C0020C26CB2C8004C0028C791C800002900320076000000000000
executable := mem.executable(Addrs, RegionSize)
SB_SetText(" 재단지침서 2-4 가니쉬 제작(Lv2) 쓰기", 1)
}
else if (코드 = "재단지침서 2-5 레더슈즈 제작(Lv2)") {
Addrs := 0x00590A00
RegionSize := 0x2048
target = 1A2D00590A32B86850E8D100590AE8458D00590A1AB808FFEA82DBE920C988C288B3540028C791C81C002900320076004C0000000000000000
executable := mem.executable(Addrs, RegionSize)
SB_SetText(" 재단지침서 2-5 레더슈즈 제작(Lv2) 쓰기", 1)
}
else if (코드 = "재단지침서 2-6 레더아머 제작(Lv2)") {
Addrs := 0x00590A00
RegionSize := 0x2048
target = 1A2D00590A32B86850E8D100590AE8458D00590A1AB808FFEA82DBE920BA38C544B3540028C791C81C002900320076004C0000000000000000
executable := mem.executable(Addrs, RegionSize)
SB_SetText(" 재단지침서 2-6 레더아머 제작(Lv2) 쓰기", 1)
}
else if (코드 = "재단지침서 2-7 수영모 제작(Lv2)") {
Addrs := 0x00590A00
RegionSize := 0x2048
target = 1A2D00590A30B86850E8D100590AE8458D00590A1AC218FFEA82DBE91C0020BAA8C601004C0028C791C800002900320076000000000000
executable := mem.executable(Addrs, RegionSize)
SB_SetText(" 재단지침서 2-7 수영모 제작(Lv2) 쓰기", 1)
}
else if (코드 = "재단지침서 2-8 꽃무늬수영모 제작(Lv2)") {
Addrs := 0x00590A00
RegionSize := 0x2048
target = 1A2D00590A36B86850E8D100590AE8458D00590A1AAF43FFEA82DBE901C218B2ACBB34C81C0020BAA8C676004C0028C791000000290032000000000000
executable := mem.executable(Addrs, RegionSize)
SB_SetText(" 재단지침서 2-8 꽃무늬수영모 제작(Lv2) 쓰기", 1)
}
else if (코드 = "재단지침서 3-1 울슈즈 제작(Lv3)") {
Addrs := 0x00590A00
RegionSize := 0x2048
target = 1A2D00590A30B86850E8D100590AE8458D00590A1AC6B8FFEA82DBE91C0020C988C288004C0028C791C800002900330076000000000000
executable := mem.executable(Addrs, RegionSize)
SB_SetText(" 재단지침서 3-1 울슈즈 제작(Lv3) 쓰기", 1)
}
else if (코드 = "재단지침서 3-2 밤슈즈 제작(Lv3)") {
Addrs := 0x00590A00
RegionSize := 0x2048
target = 1A2D00590A30B86850E8D100590AE8458D00590A1ABC24FFEA82DBE91C0020C988C288004C0028C791C800002900330076000000000000
executable := mem.executable(Addrs, RegionSize)
SB_SetText(" 재단지침서 3-2 밤슈즈 제작(Lv3) 쓰기", 1)
}
else if (코드 = "재단지침서 4-1 밧줄 제작(Lv4)") {
Addrs := 0x00590A00
RegionSize := 0x2048
target = 1A2D00590A2EB86850E8D100590AE8458D00590A1ABC27FFEA82DBE991C81C0020C9040076004C0028C70000000029003400000000
executable := mem.executable(Addrs, RegionSize)
SB_SetText(" 재단지침서 4-1 밧줄 제작(Lv4) 쓰기", 1)
}
else if (코드 = "재단지침서 4-2 꽃무늬반바지 제작(Lv4)") {
Addrs := 0x00590A00
RegionSize := 0x2048
target = 1A2D00590A36B86850E8D100590AE8458D00590A1AAF43FFEA82DBE914BC18B2ACBB34C81C0020C9C0BC76004C0028C791000000290034000000000000
executable := mem.executable(Addrs, RegionSize)
SB_SetText(" 재단지침서 4-2 꽃무늬반바지 제작(Lv4) 쓰기", 1)
}
else if (코드 = "재단지침서 4-3 꽃무늬바지 제작(Lv4)") {
Addrs := 0x00590A00
RegionSize := 0x2048
target = 1A2D00590A34B86850E8D100590AE8458D00590A1AAF43FFEA82DBE9C0BC14B2ACBB34C791C81C0020C9340076004C002800000000002900000000
executable := mem.executable(Addrs, RegionSize)
SB_SetText(" 재단지침서 4-3 꽃무늬바지 제작(Lv4) 쓰기", 1)
}
else if (코드 = "재단지침서 4-4 꽃무늬치마 제작(Lv4)") {
Addrs := 0x00590A00
RegionSize := 0x2048
target = 1A2D00590A34B86850E8D100590AE8458D00590A1AAF43FFEA82DBE9C8CE58B2ACBB34C791C81C0020B9340076004C002800000000002900000000
executable := mem.executable(Addrs, RegionSize)
SB_SetText(" 재단지침서 4-4 꽃무늬치마 제작(Lv4) 쓰기", 1)
}
else if (코드 = "재단지침서 4-5 줄무늬바지 제작(Lv4)") {
Addrs := 0x00590A00
RegionSize := 0x2048
target = 1A2D00590A34B86850E8D100590AE8458D00590A1AC904FFEA82DBE9C0BC14B2ACBB34C791C81C0020C9340076004C002800000000002900000000
executable := mem.executable(Addrs, RegionSize)
SB_SetText(" 재단지침서 4-5 줄무늬바지 제작(Lv4) 쓰기", 1)
}
else if (코드 = "재단지침서 4-6 나팔바지 제작(Lv4)") {
Addrs := 0x00590A00
RegionSize := 0x2048
target = 1A2D00590A32B86850E8D100590AE8458D00590A1AB098FFEA82DBE920C9C0BC14D3140028C791C81C002900340076004C0000000000000000
executable := mem.executable(Addrs, RegionSize)
SB_SetText(" 재단지침서 4-6 나팔바지 제작(Lv4) 쓰기", 1)
}
else if (코드 = "재단지침서 4-7 칠부바지 제작(Lv4)") {
Addrs := 0x00590A00
RegionSize := 0x2048
target = 1A2D00590A32B86850E8D100590AE8458D00590A1ACE60FFEA82DBE920C9C0BC14BD800028C791C81C002900340076004C0000000000000000
executable := mem.executable(Addrs, RegionSize)
SB_SetText(" 재단지침서 4-7 칠부바지 제작(Lv4) 쓰기", 1)
}
else if (코드 = "재단지침서 4-8 꽃무늬튜닉 제작(Lv4)") {
Addrs := 0x00590A00
RegionSize := 0x2048
target = 1A2D00590A34B86850E8D100590AE8458D00590A1AAF43FFEA82DBE9C9D29CB2ACBB34C791C81C0020B2340076004C002800000000002900000000
executable := mem.executable(Addrs, RegionSize)
SB_SetText(" 재단지침서 4-8 꽃무늬튜닉 제작(Lv4) 쓰기", 1)
}
else if (코드 = "재단지침서 4-9 줄무늬튜닉 제작(Lv4)") {
Addrs := 0x00590A00
RegionSize := 0x2048
target = 1A2D00590A34B86850E8D100590AE8458D00590A1AC904FFEA82DBE9C9D29CB2ACBB34C791C81C0020B2340076004C002800000000002900000000
executable := mem.executable(Addrs, RegionSize)
SB_SetText(" 재단지침서 4-9 줄무늬튜닉 제작(Lv4) 쓰기", 1)
}
else if (코드 = "재단지침서 4-10 터번 제작(Lv4)") {
Addrs := 0x00590A00
RegionSize := 0x2048
target = 1A2D00590A2EB86850E8D100590AE8458D00590A1AD130FFEA82DBE991C81C0020BC880076004C0028C70000000029003400000000
executable := mem.executable(Addrs, RegionSize)
SB_SetText(" 재단지침서 4-10 터번 제작(Lv4) 쓰기", 1)
}
else if (코드 = "재단지침서 4-11 볼륨업브라 제작(Lv4)") {
Addrs := 0x00590A00
RegionSize := 0x2048
target = 1A2D00590A34B86850E8D100590AE8458D00590A1ABCFCFFEA82DBE97CBE0CC5C5B968C791C81C0020B7340076004C002800000000002900000000
executable := mem.executable(Addrs, RegionSize)
SB_SetText(" 재단지침서 4-11 볼륨업브라 제작(Lv4) 쓰기", 1)
}
else if (코드 = "재단지침서 4-12 탑 제작(Lv4)") {
Addrs := 0x00590A00
RegionSize := 0x2048
target = 1A2D00590A2CB86850E8D100590AE8458D00590A1AD0D1FFEA82DBE928C791C81C002000340076004C00000000000000290000
executable := mem.executable(Addrs, RegionSize)
SB_SetText(" 재단지침서 4-12 탑 제작(Lv4) 쓰기", 1)
}
else if (코드 = "재단지침서 4-13 미니스커트 제작(Lv4)") {
Addrs := 0x00590A00
RegionSize := 0x2048
target = 1A2D00590A34B86850E8D100590AE8458D00590A1ABBF8FFEA82DBE9B8CEE4C2A4B2C8C791C81C0020D2340076004C002800000000002900000000
executable := mem.executable(Addrs, RegionSize)
SB_SetText(" 재단지침서 4-13 미니스커트 제작(Lv4) 쓰기", 1)
}
else if (코드 = "재단지침서 4-14 햅번민소매 제작(Lv4)") {
Addrs := 0x00590A00
RegionSize := 0x2048
target = 1A2D00590A34B86850E8D100590AE8458D00590A1AD585FFEA82DBE9E4C18CBBFCBC88C791C81C0020B9340076004C002800000000002900000000
executable := mem.executable(Addrs, RegionSize)
SB_SetText(" 재단지침서 4-14 햅번민소매 제작(Lv4) 쓰기", 1)
}
else if (코드 = "재단지침서 4-15 햅번긴소매 제작(Lv4)") {
Addrs := 0x00590A00
RegionSize := 0x2048
target = 1A2D00590A34B86850E8D100590AE8458D00590A1AD585FFEA82DBE9E4C18CAE34BC88C791C81C0020B9340076004C002800000000002900000000
executable := mem.executable(Addrs, RegionSize)
SB_SetText(" 재단지침서 4-15 햅번긴소매 제작(Lv4) 쓰기", 1)
}
else if (코드 = "재단지침서 4-16 땡땡브라 제작(Lv4)") {
Addrs := 0x00590A00
RegionSize := 0x2048
target = 1A2D00590A32B86850E8D100590AE8458D00590A1AB561FFEA82DBE920B77CBE0CB5610028C791C81C002900340076004C0000000000000000
executable := mem.executable(Addrs, RegionSize)
SB_SetText(" 재단지침서 4-16 땡땡브라 제작(Lv4) 쓰기", 1)
}
else if (코드 = "재단지침서 4-17 니혼모자 제작(Lv4)") {
Addrs := 0x00590A00
RegionSize := 0x2048
target = 1A2D00590A32B86850E8D100590AE8458D00590A1AB2C8FFEA82DBE920C790BAA8D63C0028C791C81C002900340076004C0000000000000000
executable := mem.executable(Addrs, RegionSize)
SB_SetText(" 재단지침서 4-17 니혼모자 제작(Lv4) 쓰기", 1)
}
else if (코드 = "재단지침서 5-1 튜닉 제작2(Lv5)") {
Addrs := 0x00590A00
RegionSize := 0x2048
target = 1A2D00590A30B86850E8D100590AE8458D00590A1AD29CFFEA82DBE991C81C0020B2C9004C00280032C700002900350076000000000000
executable := mem.executable(Addrs, RegionSize)
SB_SetText(" 재단지침서 5-1 튜닉 제작2(Lv5) 쓰기", 1)
}
else if (코드 = "재단지침서 5-2 반바지 제작2(Lv5)") {
Addrs := 0x00590A00
RegionSize := 0x2048
target = 1A2D00590A32B86850E8D100590AE8458D00590A1ABC18FFEA82DBE91C0020C9C0BC1400280032C791C82900350076004C0000000000000000
executable := mem.executable(Addrs, RegionSize)
SB_SetText(" 재단지침서 5-2 반바지 제작2(Lv5) 쓰기", 1)
}
else if (코드 = "재단지침서 5-3 바지 제작2(Lv5)") {
Addrs := 0x00590A00
RegionSize := 0x2048
target = 1A2D00590A30B86850E8D100590AE8458D00590A1ABC14FFEA82DBE991C81C0020C9C0004C00280032C700002900350076000000000000
executable := mem.executable(Addrs, RegionSize)
SB_SetText(" 재단지침서 5-3 바지 제작2(Lv5) 쓰기", 1)
}
else if (코드 = "재단지침서 5-4 가니쉬 제작2(Lv5)") {
Addrs := 0x00590A00
RegionSize := 0x2048
target = 1A2D00590A32B86850E8D100590AE8458D00590A1AAC00FFEA82DBE91C0020C26CB2C800280032C791C82900350076004C0000000000000000
executable := mem.executable(Addrs, RegionSize)
SB_SetText(" 재단지침서 5-4 가니쉬 제작2(Lv5) 쓰기", 1)
}
else if (코드 = "재단지침서 5-5 레더아머 제작2(Lv5)") {
Addrs := 0x00590A00
RegionSize := 0x2048
target = 1A2D00590A34B86850E8D100590AE8458D00590A1AB808FFEA82DBE920BA38C544B3540032C791C81C00350076004C002800000000002900000000
executable := mem.executable(Addrs, RegionSize)
SB_SetText(" 재단지침서 5-5 레더아머 제작2(Lv5) 쓰기", 1)
}
else if (코드 = "재단지침서 5-6 레더슈즈 제작2(Lv5)") {
Addrs := 0x00590A00
RegionSize := 0x2048
target = 1A2D00590A34B86850E8D100590AE8458D00590A1AB808FFEA82DBE920C988C288B3540032C791C81C00350076004C002800000000002900000000
executable := mem.executable(Addrs, RegionSize)
SB_SetText(" 재단지침서 5-6 레더슈즈 제작2(Lv5) 쓰기", 1)
}
else if (코드 = "재단지침서 5-7 울슈즈 제작2(Lv5)") {
Addrs := 0x00590A00
RegionSize := 0x2048
target = 1A2D00590A32B86850E8D100590AE8458D00590A1AC6B8FFEA82DBE91C0020C988C28800280032C791C82900350076004C0000000000000000
executable := mem.executable(Addrs, RegionSize)
SB_SetText(" 재단지침서 5-7 울슈즈 제작2(Lv5) 쓰기", 1)
}
else if (코드 = "재단지침서 5-8 밤슈즈 제작2(Lv5)") {
Addrs := 0x00590A00
RegionSize := 0x2048
target = 1A2D00590A32B86850E8D100590AE8458D00590A1ABC24FFEA82DBE91C0020C988C28800280032C791C82900350076004C0000000000000000
executable := mem.executable(Addrs, RegionSize)
SB_SetText(" 재단지침서 5-8 밤슈즈 제작2(Lv5) 쓰기", 1)
}
else if (코드 = "재단지침서 5-9 수영모 제작2(Lv5)") {
Addrs := 0x00590A00
RegionSize := 0x2048
target = 1A2D00590A32B86850E8D100590AE8458D00590A1AC218FFEA82DBE91C0020BAA8C60100280032C791C82900350076004C0000000000000000
executable := mem.executable(Addrs, RegionSize)
SB_SetText(" 재단지침서 5-9 수영모 제작2(Lv5) 쓰기", 1)
}
else if (코드 = "재단지침서 5-10 꽃무늬수영모 제작2(Lv5)") {
Addrs := 0x00590A00
RegionSize := 0x2048
target = 1A2D00590A38B86850E8D100590AE8458D00590A1AAF43FFEA82DBE901C218B2ACBB34C81C0020BAA8C64C00280032C7910029003500760000000000000000
executable := mem.executable(Addrs, RegionSize)
SB_SetText(" 재단지침서 5-10 꽃무늬수영모 제작2(Lv5) 쓰기", 1)
}
else if (코드 = "세공지침서 1-1 기초 세공(Lv1)") {
Addrs := 0x00590A00
RegionSize := 0x2048
target = 1A2D00590A2EB86850E8D100590AE8458D00590A1AAE30FFEA82DBE9F5C1380020CD080076004C0028AC0000000029003100000000
executable := mem.executable(Addrs, RegionSize)
SB_SetText(" 세공지침서 1-1 기초 세공(Lv1) 쓰기", 1)
}
else if (코드 = "세공지침서 1-2 링 수리(Lv1)") {
Addrs := 0x00590A00
RegionSize := 0x2048
target = 1A2D00590A2CB86850E8D100590AE8458D00590A1AB9C1FFEA82DBE928B9ACC218002000310076004C00000000000000290000
executable := mem.executable(Addrs, RegionSize)
SB_SetText(" 세공지침서 1-2 링 수리(Lv1) 쓰기", 1)
}
else if (코드 = "세공지침서 1-3 네클리스 수리(Lv1)") {
Addrs := 0x00590A00
RegionSize := 0x2048
target = 1A2D00590A32B86850E8D100590AE8458D00590A1AB124FFEA82DBE920C2A4B9ACD0740028B9ACC218002900310076004C0000000000000000
executable := mem.executable(Addrs, RegionSize)
SB_SetText(" 세공지침서 1-3 네클리스 수리(Lv1) 쓰기", 1)
}
else if (코드 = "세공지침서 2-1 브리디온 가공(Lv2)") {
Addrs := 0x00590A00
RegionSize := 0x2048
target = 1A2D00590A32B86850E8D100590AE8458D00590A1ABE0CFFEA82DBE920C628B514B9AC0028ACF5AC00002900320076004C0000000000000000
executable := mem.executable(Addrs, RegionSize)
SB_SetText(" 세공지침서 2-1 브리디온 가공(Lv2) 쓰기", 1)
}
else if (코드 = "세공지침서 2-2 다니온 가공(Lv2)") {
Addrs := 0x00590A00
RegionSize := 0x2048
target = 1A2D00590A30B86850E8D100590AE8458D00590A1AB2E4FFEA82DBE9000020C628B2C8004C0028ACF5AC00002900320076000000000000
executable := mem.executable(Addrs, RegionSize)
SB_SetText(" 세공지침서 2-2 다니온 가공(Lv2) 쓰기", 1)
}
else if (코드 = "세공지침서 2-3 마하디온 가공(Lv2)") {
Addrs := 0x00590A00
RegionSize := 0x2048
target = 1A2D00590A32B86850E8D100590AE8458D00590A1AB9C8FFEA82DBE920C628B514D5580028ACF5AC00002900320076004C0000000000000000
executable := mem.executable(Addrs, RegionSize)
SB_SetText(" 세공지침서 2-3 마하디온 가공(Lv2) 쓰기", 1)
}
else if (코드 = "세공지침서 2-4 브라키디온 가공(Lv2)") {
Addrs := 0x00590A00
RegionSize := 0x2048
target = 1A2D00590A34B86850E8D100590AE8458D00590A1ABE0CFFEA82DBE928B514D0A4B77CACF5AC000020C6320076004C002800000000002900000000
executable := mem.executable(Addrs, RegionSize)
SB_SetText(" 세공지침서 2-4 브라키디온 가공(Lv2) 쓰기", 1)
}
else if (코드 = "세공지침서 2-5 브라키디온 가공(Lv2)") {
Addrs := 0x00590A00
RegionSize := 0x2048
target = 1A2D00590A34B86850E8D100590AE8458D00590A1ABE0CFFEA82DBE928B514D0A4B77CACF5AC000020C6320076004C002800000000002900000000
executable := mem.executable(Addrs, RegionSize)
SB_SetText(" 세공지침서 2-5 브라키디온 가공(Lv2) 쓰기", 1)
}
else if (코드 = "세공지침서 2-6 테사랏티온 가공(Lv2)") {
Addrs := 0x00590A00
RegionSize := 0x2048
target = 1A2D00590A34B86850E8D100590AE8458D00590A1AD14CFFEA82DBE928D2F0B78FC0ACACF5AC000020C6320076004C002800000000002900000000
executable := mem.executable(Addrs, RegionSize)
SB_SetText(" 세공지침서 2-6 테사랏티온 가공(Lv2) 쓰기", 1)
}
else if (코드 = "세공지침서 3-1 알티브리디온 가공(Lv3)") {
Addrs := 0x00590A00
RegionSize := 0x2048
target = 1A2D00590A36B86850E8D100590AE8458D00590A1AC54CFFEA82DBE914B9ACBE0CD2F0AC000020C628B576004C0028ACF5000000290033000000000000
executable := mem.executable(Addrs, RegionSize)
SB_SetText(" 세공지침서 3-1 알티브리디온 가공(Lv3) 쓰기", 1)
}
else if (코드 = "세공지침서 3-2 알티다니온 가공(Lv3)") {
Addrs := 0x00590A00
RegionSize := 0x2048
target = 1A2D00590A34B86850E8D100590AE8458D00590A1AC54CFFEA82DBE928B2C8B2E4D2F0ACF5AC000020C6330076004C002800000000002900000000
executable := mem.executable(Addrs, RegionSize)
SB_SetText(" 세공지침서 3-2 알티다니온 가공(Lv3) 쓰기", 1)
}
else if (코드 = "세공지침서 3-3 알티마하디온 가공(Lv3)") {
Addrs := 0x00590A00
RegionSize := 0x2048
target = 1A2D00590A36B86850E8D100590AE8458D00590A1AC54CFFEA82DBE914D558B9C8D2F0AC000020C628B576004C0028ACF5000000290033000000000000
executable := mem.executable(Addrs, RegionSize)
SB_SetText(" 세공지침서 3-3 알티마하디온 가공(Lv3) 쓰기", 1)
}
else if (코드 = "세공지침서 3-4 알티브라키디온 가공(Lv3)") {
Addrs := 0x00590A00
RegionSize := 0x2048
target = 1A2D00590A38B86850E8D100590AE8458D00590A1AC54CFFEA82DBE9A4B77CBE0CD2F00020C628B514D04C0028ACF5AC000029003300760000000000000000
executable := mem.executable(Addrs, RegionSize)
SB_SetText(" 세공지침서 3-4 알티브라키디온 가공(Lv3) 쓰기", 1)
}
else if (코드 = "세공지침서 3-5 볼바디온 가공(Lv3)") {
Addrs := 0x00590A00
RegionSize := 0x2048
target = 1A2D00590A32B86850E8D100590AE8458D00590A1ABCFCFFEA82DBE920C628B514BC140028ACF5AC00002900330076004C0000000000000000
executable := mem.executable(Addrs, RegionSize)
SB_SetText(" 세공지침서 3-5 볼바디온 가공(Lv3) 쓰기", 1)
}
else if (코드 = "세공지침서 3-6 테사리온 가공(Lv3)") {
Addrs := 0x00590A00
RegionSize := 0x2048
target = 1A2D00590A32B86850E8D100590AE8458D00590A1AD14CFFEA82DBE920C628B9ACC0AC0028ACF5AC00002900330076004C0000000000000000
executable := mem.executable(Addrs, RegionSize)
SB_SetText(" 세공지침서 3-6 테사리온 가공(Lv3) 쓰기", 1)
}
else if (코드 = "세공지침서 4-1 브리시온(원석) 가공(Lv4)") {
Addrs := 0x00590A00
RegionSize := 0x2048
target = 1A2D00590A3AB86850E8D100590AE8458D00590A1ABE0CFFEA82DBE928C628C2DCB9AC0029C11DC6D00028ACF5AC00002000340076004C00000000000000290000
executable := mem.executable(Addrs, RegionSize)
SB_SetText(" 세공지침서 4-1 브리시온(원석) 가공(Lv4) 쓰기", 1)
}
else if (코드 = "세공지침서 4-2 다니시온(원석) 가공(Lv4)") {
Addrs := 0x00590A00
RegionSize := 0x2048
target = 1A2D00590A3AB86850E8D100590AE8458D00590A1AB2E4FFEA82DBE928C628C2DCB2C80029C11DC6D00028ACF5AC00002000340076004C00000000000000290000
executable := mem.executable(Addrs, RegionSize)
SB_SetText(" 세공지침서 4-2 다니시온(원석) 가공(Lv4) 쓰기", 1)
}
else if (코드 = "세공지침서 4-3 마흐시온(원석) 가공(Lv4)") {
Addrs := 0x00590A00
RegionSize := 0x2048
target = 1A2D00590A3AB86850E8D100590AE8458D00590A1AB9C8FFEA82DBE928C628C2DCD7500029C11DC6D00028ACF5AC00002000340076004C00000000000000290000
executable := mem.executable(Addrs, RegionSize)
SB_SetText(" 세공지침서 4-3 마흐시온(원석) 가공(Lv4) 쓰기", 1)
}
else if (코드 = "세공지침서 4-4 브라키시온(원석) 가공(Lv4)") {
Addrs := 0x00590A00
RegionSize := 0x2048
target = 1A2D00590A3CB86850E8D100590AE8458D00590A1ABE0CFFEA82DBE928C2DCD0A4B77CC11DC6D00028C6F5AC00002000290076004C0028AC0000000029003400000000
executable := mem.executable(Addrs, RegionSize)
SB_SetText("세공지침서 4-4 브라키시온(원석) 가공(Lv4) 쓰기", 1)
}
else if (코드 = "세공지침서 4-5 엘리시온(원석) 가공(Lv4)") {
Addrs := 0x00590A00
RegionSize := 0x2048
target = 1A2D00590A3AB86850E8D100590AE8458D00590A1AC5D8FFEA82DBE928C628C2DCB9AC0029C11DC6D00028ACF5AC00002000340076004C00000000000000290000
executable := mem.executable(Addrs, RegionSize)
SB_SetText(" 세공지침서 4-5 엘리시온(원석) 가공(Lv4) 쓰기", 1)
}
else if (코드 = "세공지침서 4-6 테스시온(원석) 가공(Lv4)") {
Addrs := 0x00590A00
RegionSize := 0x2048
target = 1A2D00590A3AB86850E8D100590AE8458D00590A1AD14CFFEA82DBE928C628C2DCC2A40029C11DC6D00028ACF5AC00002000340076004C00000000000000290000
executable := mem.executable(Addrs, RegionSize)
SB_SetText(" 세공지침서 4-6 테스시온(원석) 가공(Lv4) 쓰기", 1)
}
else if (코드 = "세공지침서 5-1 브리시온 가공(Lv5)") {
Addrs := 0x00590A00
RegionSize := 0x2048
target = 1A2D00590A32B86850E8D100590AE8458D00590A1ABE0CFFEA82DBE920C628C2DCB9AC0028ACF5AC00002900350076004C0000000000000000
executable := mem.executable(Addrs, RegionSize)
SB_SetText(" 세공지침서 5-1 브리시온 가공(Lv5) 쓰기", 1)
}
else if (코드 = "세공지침서 5-2 다니시온 가공(Lv5)") {
Addrs := 0x00590A00
RegionSize := 0x2048
target = 1A2D00590A32B86850E8D100590AE8458D00590A1AB2E4FFEA82DBE920C628C2DCB2C80028ACF5AC00002900350076004C0000000000000000
executable := mem.executable(Addrs, RegionSize)
SB_SetText(" 세공지침서 5-2 다니시온 가공(Lv5) 쓰기", 1)
}
else if (코드 = "세공지침서 5-3 마흐시온 가공(Lv5)") {
Addrs := 0x00590A00
RegionSize := 0x2048
target = 1A2D00590A32B86850E8D100590AE8458D00590A1AB9C8FFEA82DBE920C628C2DCD7500028ACF5AC00002900350076004C0000000000000000
executable := mem.executable(Addrs, RegionSize)
SB_SetText(" 세공지침서 5-3 마흐시온 가공(Lv5) 쓰기", 1)
}
else if (코드 = "세공지침서 5-4 브라키시온 가공(Lv5)") {
Addrs := 0x00590A00
RegionSize := 0x2048
target = 1A2D00590A34B86850E8D100590AE8458D00590A1ABE0CFFEA82DBE928C2DCD0A4B77CACF5AC000020C6350076004C002800000000002900000000
executable := mem.executable(Addrs, RegionSize)
SB_SetText(" 세공지침서 5-4 브라키시온 가공(Lv5) 쓰기", 1)
}
else if (코드 = "세공지침서 5-5 엘리시온 가공(Lv5)") {
Addrs := 0x00590A00
RegionSize := 0x2048
target = 1A2D00590A32B86850E8D100590AE8458D00590A1AC5D8FFEA82DBE920C628C2DCB9AC0028ACF5AC00002900350076004C0000000000000000
executable := mem.executable(Addrs, RegionSize)
SB_SetText(" 세공지침서 5-5 엘리시온 가공(Lv5) 쓰기", 1)
}
else if (코드 = "세공지침서 5-6 테스시온 가공(Lv5)") {
Addrs := 0x00590A00
RegionSize := 0x2048
target = 1A2D00590A32B86850E8D100590AE8458D00590A1AD14CFFEA82DBE920C628C2DCC2A40028ACF5AC00002900350076004C0000000000000000
executable := mem.executable(Addrs, RegionSize)
SB_SetText(" 세공지침서 5-6 테스시온 가공(Lv5) 쓰기", 1)
}
else if (코드 = "세공지침서 6-1 아이언링 제작1(Lv6)") {
Addrs := 0x00590A00
RegionSize := 0x2048
target = 1A2D00590A34B86850E8D100590AE8458D00590A1AC544FFEA82DBE920B9C1C5B8C7740031C791C81C00360076004C002800000000002900000000
executable := mem.executable(Addrs, RegionSize)
SB_SetText(" 세공지침서 6-1 아이언링 제작1(Lv6) 쓰기", 1)
}
else if (코드 = "세공지침서 6-2 실버링 제작1(Lv6)") {
Addrs := 0x00590A00
RegionSize := 0x2048
target = 1A2D00590A32B86850E8D100590AE8458D00590A1AC2E4FFEA82DBE91C0020B9C1BC8400280031C791C82900360076004C0000000000000000
executable := mem.executable(Addrs, RegionSize)
SB_SetText(" 세공지침서 6-2 실버링 제작1(Lv6) 쓰기", 1)
}
else if (코드 = "세공지침서 6-3 골드링 제작1(Lv6)") {
Addrs := 0x00590A00
RegionSize := 0x2048
target = 1A2D00590A32B86850E8D100590AE8458D00590A1AACE8FFEA82DBE91C0020B9C1B4DC00280031C791C82900360076004C0000000000000000
executable := mem.executable(Addrs, RegionSize)
SB_SetText(" 세공지침서 6-3 골드링 제작1(Lv6) 쓰기", 1)
}
else if (코드 = "세공지침서 6-4 에메랄드링 제작1(Lv6)") {
Addrs := 0x00590A00
RegionSize := 0x2048
target = 1A2D00590A36B86850E8D100590AE8458D00590A1AC5D0FFEA82DBE9C1B4DCB784BA54C791C81C0020B976004C00280031000000290036000000000000
executable := mem.executable(Addrs, RegionSize)
SB_SetText(" 세공지침서 6-4 에메랄드링 제작1(Lv6) 쓰기", 1)
}
else if (코드 = "세공지침서 6-5 사파이어링 제작1(Lv6)") {
Addrs := 0x00590A00
RegionSize := 0x2048
target = 1A2D00590A36B86850E8D100590AE8458D00590A1AC0ACFFEA82DBE9C1C5B4C774D30CC791C81C0020B976004C00280031000000290036000000000000
executable := mem.executable(Addrs, RegionSize)
SB_SetText(" 세공지침서 6-5 사파이어링 제작1(Lv6) 쓰기", 1)
}
else if (코드 = "세공지침서 6-6 투어마린링 제작1(Lv6)") {
Addrs := 0x00590A00
RegionSize := 0x2048
target = 1A2D00590A36B86850E8D100590AE8458D00590A1AD22CFFEA82DBE9C1B9B0B9C8C5B4C791C81C0020B976004C00280031000000290036000000000000
executable := mem.executable(Addrs, RegionSize)
SB_SetText(" 세공지침서 6-6 투어마린링 제작1(Lv6) 쓰기", 1)
}
else if (코드 = "세공지침서 6-7 브리디온링 제작1(Lv6)") {
Addrs := 0x00590A00
RegionSize := 0x2048
target = 1A2D00590A36B86850E8D100590AE8458D00590A1ABE0CFFEA82DBE9C1C628B514B9ACC791C81C0020B976004C00280031000000290036000000000000
executable := mem.executable(Addrs, RegionSize)
SB_SetText(" 세공지침서 6-7 브리디온링 제작1(Lv6) 쓰기", 1)
}
else if (코드 = "세공지침서 6-8 다니온링 제작1(Lv6)") {
Addrs := 0x00590A00
RegionSize := 0x2048
target = 1A2D00590A34B86850E8D100590AE8458D00590A1AB2E4FFEA82DBE920B9C1C628B2C80031C791C81C00360076004C002800000000002900000000
executable := mem.executable(Addrs, RegionSize)
SB_SetText(" 세공지침서 6-8 다니온링 제작1(Lv6) 쓰기", 1)
}
else if (코드 = "세공지침서 6-9 마하디온링 제작1(Lv6)") {
Addrs := 0x00590A00
RegionSize := 0x2048
target = 1A2D00590A36B86850E8D100590AE8458D00590A1AB9C8FFEA82DBE9C1C628B514D558C791C81C0020B976004C00280031000000290036000000000000
executable := mem.executable(Addrs, RegionSize)
SB_SetText(" 세공지침서 6-9 마하디온링 제작1(Lv6) 쓰기", 1)
}
else if (코드 = "세공지침서 6-10 브라키디온링 제작1(Lv6)") {
Addrs := 0x00590A00
RegionSize := 0x2048
target = 1A2D00590A38B86850E8D100590AE8458D00590A1ABE0CFFEA82DBE928B514D0A4B77CC81C0020B9C1C64C00280031C7910029003600760000000000000000
executable := mem.executable(Addrs, RegionSize)
SB_SetText(" 세공지침서 6-10 브라키디온링 제작1(Lv6) 쓰기", 1)
}
else if (코드 = "세공지침서 6-11 엘사리온링 제작1(Lv6)") {
Addrs := 0x00590A00
RegionSize := 0x2048
target = 1A2D00590A36B86850E8D100590AE8458D00590A1AC5D8FFEA82DBE9C1C628B9ACC0ACC791C81C0020B976004C00280031000000290036000000000000
executable := mem.executable(Addrs, RegionSize)
SB_SetText(" 세공지침서 6-11 엘사리온링 제작1(Lv6) 쓰기", 1)
}
else if (코드 = "세공지침서 6-12 테사리온링 제작1(Lv6)") {
Addrs := 0x00590A00
RegionSize := 0x2048
target = 1A2D00590A36B86850E8D100590AE8458D00590A1AD14CFFEA82DBE9C1C628B9ACC0ACC791C81C0020B976004C00280031000000290036000000000000
executable := mem.executable(Addrs, RegionSize)
SB_SetText(" 세공지침서 6-12 테사리온링 제작1(Lv6) 쓰기", 1)
}
else if (코드 = "세공지침서 7-1 아이언네클리스 제작1(Lv7)") {
Addrs := 0x00590A00
RegionSize := 0x2048
target = 1A2D00590A3AB86850E8D100590AE8458D00590A1AC544FFEA82DBE974B124C5B8C7740020C2A4B9ACD0280031C791C81C00370076004C00000000000000290000
executable := mem.executable(Addrs, RegionSize)
SB_SetText(" 세공지침서 7-1 아이언네클리스 제작1(Lv7) 쓰기", 1)
}
else if (코드 = "세공지침서 7-2 실버네클리스 제작1(Lv7)") {
Addrs := 0x00590A00
RegionSize := 0x2048
target = 1A2D00590A38B86850E8D100590AE8458D00590A1AC2E4FFEA82DBE9ACD074B124BC84C81C0020C2A4B94C00280031C7910029003700760000000000000000
executable := mem.executable(Addrs, RegionSize)
SB_SetText(" 세공지침서 7-2 실버네클리스 제작1(Lv7) 쓰기", 1)
}
else if (코드 = "세공지침서 7-3 골드네클리스 제작1(Lv7)") {
Addrs := 0x00590A00
RegionSize := 0x2048
target = 1A2D00590A38B86850E8D100590AE8458D00590A1AACE8FFEA82DBE9ACD074B124B4DCC81C0020C2A4B94C00280031C7910029003700760000000000000000
executable := mem.executable(Addrs, RegionSize)
SB_SetText(" 세공지침서 7-3 골드네클리스 제작1(Lv7) 쓰기", 1)
}
else if (코드 = "세공지침서 7-4 루비네클리스 제작1(Lv7)") {
Addrs := 0x00590A00
RegionSize := 0x2048
target = 1A2D00590A38B86850E8D100590AE8458D00590A1AB8E8FFEA82DBE9ACD074B124BE44C81C0020C2A4B94C00280031C7910029003700760000000000000000
executable := mem.executable(Addrs, RegionSize)
SB_SetText(" 세공지침서 7-4 루비네클리스 제작1(Lv7) 쓰기", 1)
}
else if (코드 = "세공지침서 7-5 상아네클리스 제작1(Lv7)") {
Addrs := 0x00590A00
RegionSize := 0x2048
target = 1A2D00590A38B86850E8D100590AE8458D00590A1AC0C1FFEA82DBE9ACD074B124C544C81C0020C2A4B94C00280031C7910029003700760000000000000000
executable := mem.executable(Addrs, RegionSize)
SB_SetText(" 세공지침서 7-5 상아네클리스 제작1(Lv7) 쓰기", 1)
}
else if (코드 = "세공지침서 7-6 사파이어네클리스 제작1(Lv7)") {
Addrs := 0x00590A00
RegionSize := 0x2048
target = 1A2D00590A3CB86850E8D100590AE8458D00590A1AC0ACFFEA82DBE924C5B4C774D30CC2A4B9ACD074B131C791C81C00200076004C0028000000000029003700000000
executable := mem.executable(Addrs, RegionSize)
SB_SetText(" 세공지침서 7-6 사파이어네클리스 제작1(Lv7) 쓰기", 1)
}
else if (코드 = "세공지침서 7-7 펄네클리스 제작1(Lv7)") {
Addrs := 0x00590A00
RegionSize := 0x2048
target = 1A2D00590A36B86850E8D100590AE8458D00590A1AD384FFEA82DBE9A4B9ACD074B124C791C81C0020C276004C00280031000000290037000000000000
executable := mem.executable(Addrs, RegionSize)
SB_SetText(" 세공지침서 7-7 펄네클리스 제작1(Lv7) 쓰기", 1)
}
else if (코드 = "세공지침서 7-8 블랙펄네클리스 제작1(Lv7)") {
Addrs := 0x00590A00
RegionSize := 0x2048
target = 1A2D00590A3AB86850E8D100590AE8458D00590A1ABE14FFEA82DBE974B124D384B7990020C2A4B9ACD0280031C791C81C00370076004C00000000000000290000
executable := mem.executable(Addrs, RegionSize)
SB_SetText(" 세공지침서 7-8 블랙펄네클리스 제작1(Lv7) 쓰기", 1)
}
else if (코드 = "세공지침서 7-9 오레온 제작(Lv7)") {
Addrs := 0x00590A00
RegionSize := 0x2048
target = 1A2D00590A30B86850E8D100590AE8458D00590A1AC624FFEA82DBE91C0020C628B808004C0028C791C800002900370076000000000000
executable := mem.executable(Addrs, RegionSize)
SB_SetText(" 세공지침서 7-9 오레온 제작(Lv7) 쓰기", 1)
}
else if (코드 = "세공지침서 7-10 세레온 제작(Lv7)") {
Addrs := 0x00590A00
RegionSize := 0x2048
target = 1A2D00590A30B86850E8D100590AE8458D00590A1AC138FFEA82DBE91C0020C628B808004C0028C791C800002900370076000000000000
executable := mem.executable(Addrs, RegionSize)
SB_SetText(" 세공지침서 7-10 세레온 제작(Lv7) 쓰기", 1)
}
else if (코드 = "세공지침서 8-1 기초 가공1(Lv8)") {
Addrs := 0x00590A00
RegionSize := 0x2048
target = 1A2D00590A30B86850E8D100590AE8458D00590A1AAE30FFEA82DBE9F5AC000020CD08004C00280031AC00002900380076000000000000
executable := mem.executable(Addrs, RegionSize)
SB_SetText(" 세공지침서 8-1 기초 가공1(Lv8) 쓰기", 1)
}
else if (코드 = "세공지침서 8-2 기초 가공2(Lv8)") {
Addrs := 0x00590A00
RegionSize := 0x2048
target = 1A2D00590A30B86850E8D100590AE8458D00590A1AAE30FFEA82DBE9F5AC000020CD08004C00280032AC00002900380076000000000000
executable := mem.executable(Addrs, RegionSize)
SB_SetText(" 세공지침서 8-2 기초 가공2(Lv8) 쓰기", 1)
}
else if (코드 = "세공지침서 8-3 케이온 제작(Lv8)") {
Addrs := 0x00590A00
RegionSize := 0x2048
target = 1A2D00590A30B86850E8D100590AE8458D00590A1ACF00FFEA82DBE91C0020C628C774004C0028C791C800002900380076000000000000
executable := mem.executable(Addrs, RegionSize)
SB_SetText(" 세공지침서 8-3 케이온 제작(Lv8) 쓰기", 1)
}
else if (코드 = "세공지침서 9-1 초급 가공1(Lv9)") {
Addrs := 0x00590A00
RegionSize := 0x2048
target = 1A2D00590A30B86850E8D100590AE8458D00590A1ACD08FFEA82DBE9F5AC000020AE09004C00280031AC00002900390076000000000000
executable := mem.executable(Addrs, RegionSize)
SB_SetText(" 세공지침서 9-1 초급 가공1(Lv9) 쓰기", 1)
}
else if (코드 = "세공지침서 10-1 중급 가공1(Lv10)") {
Addrs := 0x00590A00
RegionSize := 0x2048
target = 1A2D00590A32B86850E8D100590AE8458D00590A1AC911FFEA82DBE9F5AC000020AE09004C00280031AC290030003100760000000000000000
executable := mem.executable(Addrs, RegionSize)
SB_SetText(" 세공지침서 10-1 중급 가공1(Lv10) 쓰기", 1)
}
else if (코드 = "세공지침서 11-1 고급 가공1(Lv11)") {
Addrs := 0x00590A00
RegionSize := 0x2048
target = 1A2D00590A32B86850E8D100590AE8458D00590A1AACE0FFEA82DBE9F5AC000020AE09004C00280031AC290031003100760000000000000000
executable := mem.executable(Addrs, RegionSize)
SB_SetText(" 세공지침서 11-1 고급 가공1(Lv11) 쓰기", 1)
}
else if (코드 = "미용지침서 1-1 기초 염색(Lv1)") {
Addrs := 0x00590A00
RegionSize := 0x2048
target = 1A2D00590A2EB86850E8D100590AE8458D00590A1AAE30FFEA82DBE9C9C5FC0020CD080076004C0028C00000000029003100000000
executable := mem.executable(Addrs, RegionSize)
SB_SetText(" 미용지침서 1-1 기초 염색(Lv1) 쓰기", 1)
}
else if (코드 = "미용지침서 2-1 삭발 스타일(Lv2)") {
Addrs := 0x00590A00
RegionSize := 0x2048
target = 1A2D00590A30B86850E8D100590AE8458D00590A1AC0ADFFEA82DBE9C0C2A40020BC1C004C0028C77CD000002900320076000000000000
executable := mem.executable(Addrs, RegionSize)
SB_SetText(" 미용지침서 2-1 삭발 스타일(Lv2) 쓰기", 1)
}
else if (코드 = "미용지침서 2-2 기본 스타일(Lv2)") {
Addrs := 0x00590A00
RegionSize := 0x2048
target = 1A2D00590A30B86850E8D100590AE8458D00590A1AAE30FFEA82DBE9C0C2A40020BCF8004C0028C77CD000002900320076000000000000
executable := mem.executable(Addrs, RegionSize)
SB_SetText(" 미용지침서 2-2 기본 스타일(Lv2) 쓰기", 1)
}
else if (코드 = "미용지침서 2-3 펑크 스타일(Lv2)") {
Addrs := 0x00590A00
RegionSize := 0x2048
target = 1A2D00590A30B86850E8D100590AE8458D00590A1AD391FFEA82DBE9C0C2A40020D06C004C0028C77CD000002900320076000000000000
executable := mem.executable(Addrs, RegionSize)
SB_SetText(" 미용지침서 2-3 펑크 스타일(Lv2) 쓰기", 1)
}
else if (코드 = "미용지침서 2-4 레게 스타일(Lv2)") {
Addrs := 0x00590A00
RegionSize := 0x2048
target = 1A2D00590A30B86850E8D100590AE8458D00590A1AB808FFEA82DBE9C0C2A40020AC8C004C0028C77CD000002900320076000000000000
executable := mem.executable(Addrs, RegionSize)
SB_SetText(" 미용지침서 2-4 레게 스타일(Lv2) 쓰기", 1)
}
else if (코드 = "미용지침서 2-5 변형 스타일(Lv2)") {
Addrs := 0x00590A00
RegionSize := 0x2048
target = 1A2D00590A30B86850E8D100590AE8458D00590A1ABCC0FFEA82DBE9C0C2A40020D615004C0028C77CD000002900320076000000000000
executable := mem.executable(Addrs, RegionSize)
SB_SetText(" 미용지침서 2-5 변형 스타일(Lv2) 쓰기", 1)
}
else if (코드 = "미용지침서 2-6 더벅 스타일(Lv2)") {
Addrs := 0x00590A00
RegionSize := 0x2048
target = 1A2D00590A30B86850E8D100590AE8458D00590A1AB354FFEA82DBE9C0C2A40020BC85004C0028C77CD000002900320076000000000000
executable := mem.executable(Addrs, RegionSize)
SB_SetText(" 미용지침서 2-6 더벅 스타일(Lv2) 쓰기", 1)
}
else if (코드 = "미용지침서 2-7 바람 스타일(Lv2)") {
Addrs := 0x00590A00
RegionSize := 0x2048
target = 1A2D00590A30B86850E8D100590AE8458D00590A1ABC14FFEA82DBE9C0C2A40020B78C004C0028C77CD000002900320076000000000000
executable := mem.executable(Addrs, RegionSize)
SB_SetText(" 미용지침서 2-7 바람 스타일(Lv2) 쓰기", 1)
}
else if (코드 = "미용지침서 2-8 복고 스타일(Lv2)") {
Addrs := 0x00590A00
RegionSize := 0x2048
target = 1A2D00590A30B86850E8D100590AE8458D00590A1ABCF5FFEA82DBE9C0C2A40020ACE0004C0028C77CD000002900320076000000000000
executable := mem.executable(Addrs, RegionSize)
SB_SetText(" 미용지침서 2-8 복고 스타일(Lv2) 쓰기", 1)
}
else if (코드 = "미용지침서 2-9 자연 스타일(Lv2)") {
Addrs := 0x00590A00
RegionSize := 0x2048
target = 1A2D00590A30B86850E8D100590AE8458D00590A1AC790FFEA82DBE9C0C2A40020C5F0004C0028C77CD000002900320076000000000000
executable := mem.executable(Addrs, RegionSize)
SB_SetText(" 미용지침서 2-9 자연 스타일(Lv2) 쓰기", 1)
}
else if (코드 = "미용지침서 2-10 웨이브 스타일(Lv2)") {
Addrs := 0x00590A00
RegionSize := 0x2048
target = 1A2D00590A32B86850E8D100590AE8458D00590A1AC6E8FFEA82DBE9A40020BE0CC7740028C77CD0C0C22900320076004C0000000000000000
executable := mem.executable(Addrs, RegionSize)
SB_SetText(" 미용지침서 2-10 웨이브 스타일(Lv2) 쓰기", 1)
}
else if (코드 = "미용지침서 2-11 세팅 스타일(Lv2)") {
Addrs := 0x00590A00
RegionSize := 0x2048
target = 1A2D00590A30B86850E8D100590AE8458D00590A1AC138FFEA82DBE9C0C2A40020D305004C0028C77CD000002900320076000000000000
executable := mem.executable(Addrs, RegionSize)
SB_SetText(" 미용지침서 2-11 세팅 스타일(Lv2) 쓰기", 1)
}
else if (코드 = "미용지침서 2-12 폭탄 스타일(Lv2)") {
Addrs := 0x00590A00
RegionSize := 0x2048
target = 1A2D00590A30B86850E8D100590AE8458D00590A1AD3EDFFEA82DBE9C0C2A40020D0C4004C0028C77CD000002900320076000000000000
executable := mem.executable(Addrs, RegionSize)
SB_SetText(" 미용지침서 2-12 폭탄 스타일(Lv2) 쓰기", 1)
}
else if (코드 = "미용지침서 2-13 야자수 스타일(Lv2)") {
Addrs := 0x00590A00
RegionSize := 0x2048
target = 1A2D00590A32B86850E8D100590AE8458D00590A1AC57CFFEA82DBE9A40020C218C7900028C77CD0C0C22900320076004C0000000000000000
executable := mem.executable(Addrs, RegionSize)
SB_SetText(" 미용지침서 2-13 야자수 스타일(Lv2) 쓰기", 1)
}
else if (코드 = "미용지침서 2-14 발랄 스타일(Lv2)") {
Addrs := 0x00590A00
RegionSize := 0x2048
target = 1A2D00590A30B86850E8D100590AE8458D00590A1ABC1CFFEA82DBE9C0C2A40020B784004C0028C77CD000002900320076000000000000
executable := mem.executable(Addrs, RegionSize)
SB_SetText(" 미용지침서 2-14 발랄 스타일(Lv2) 쓰기", 1)
}
else if (코드 = "미용지침서 2-15 변형레게 스타일(Lv2)") {
Addrs := 0x00590A00
RegionSize := 0x2048
target = 1A2D00590A34B86850E8D100590AE8458D00590A1ABCC0FFEA82DBE920AC8CB808D615C77CD0C0C2A400320076004C002800000000002900000000
executable := mem.executable(Addrs, RegionSize)
SB_SetText(" 미용지침서 2-15 변형레게 스타일(Lv2) 쓰기", 1)
}
else if (코드 = "미용지침서 2-16 올림 스타일(Lv2)") {
Addrs := 0x00590A00
RegionSize := 0x2048
target = 1A2D00590A30B86850E8D100590AE8458D00590A1AC62CFFEA82DBE9C0C2A40020B9BC004C0028C77CD000002900320076000000000000
executable := mem.executable(Addrs, RegionSize)
SB_SetText(" 미용지침서 2-16 올림 스타일(Lv2) 쓰기", 1)
}
else if (코드 = "미용지침서 2-17 곱슬 스타일(Lv2)") {
Addrs := 0x00590A00
RegionSize := 0x2048
target = 1A2D00590A30B86850E8D100590AE8458D00590A1AACF1FFEA82DBE9C0C2A40020C2AC004C0028C77CD000002900320076000000000000
executable := mem.executable(Addrs, RegionSize)
SB_SetText(" 미용지침서 2-17 곱슬 스타일(Lv2) 쓰기", 1)
}
else if (코드 = "미용지침서 2-18 미남스타일 변형(Lv2)") {
Addrs := 0x00590A00
RegionSize := 0x2048
target = 1A2D00590A34B86850E8D100590AE8458D00590A1ABBF8FFEA82DBE97CD0C0C2A4B0A8D615BCC00020C7320076004C002800000000002900000000
executable := mem.executable(Addrs, RegionSize)
SB_SetText(" 미용지침서 2-18 미남스타일 변형(Lv2) 쓰기", 1)
}
else if (코드 = "미용지침서 2-19 바가지 스타일(Lv2)") {
Addrs := 0x00590A00
RegionSize := 0x2048
target = 1A2D00590A32B86850E8D100590AE8458D00590A1ABC14FFEA82DBE9A40020C9C0AC000028C77CD0C0C22900320076004C0000000000000000
executable := mem.executable(Addrs, RegionSize)
SB_SetText(" 미용지침서 2-19 바가지 스타일(Lv2) 쓰기", 1)
}
else if (코드 = "미용지침서 2-20 선녀 스타일(Lv2)") {
Addrs := 0x00590A00
RegionSize := 0x2048
target = 1A2D00590A30B86850E8D100590AE8458D00590A1AC120FFEA82DBE9C0C2A40020B140004C0028C77CD000002900320076000000000000
executable := mem.executable(Addrs, RegionSize)
SB_SetText(" 미용지침서 2-20 선녀 스타일(Lv2) 쓰기", 1)
}
else if (코드 = "미용지침서 2-21 밤톨 스타일(Lv2)") {
Addrs := 0x00590A00
RegionSize := 0x2048
target = 1A2D00590A30B86850E8D100590AE8458D00590A1ABC24FFEA82DBE9C0C2A40020D1A8004C0028C77CD000002900320076000000000000
executable := mem.executable(Addrs, RegionSize)
SB_SetText(" 미용지침서 2-21 밤톨 스타일(Lv2) 쓰기", 1)
}
else if (코드 = "미용지침서 2-22 귀족 스타일(Lv2)") {
Addrs := 0x00590A00
RegionSize := 0x2048
target = 1A2D00590A30B86850E8D100590AE8458D00590A1AADC0FFEA82DBE9C0C2A40020C871004C0028C77CD000002900320076000000000000
executable := mem.executable(Addrs, RegionSize)
SB_SetText(" 미용지침서 2-22 귀족 스타일(Lv2) 쓰기", 1)
}
else if (코드 = "미용지침서 2-23 드라마 스타일(Lv2)") {
Addrs := 0x00590A00
RegionSize := 0x2048
target = 1A2D00590A32B86850E8D100590AE8458D00590A1AB4DCFFEA82DBE9A40020B9C8B77C0028C77CD0C0C22900320076004C0000000000000000
executable := mem.executable(Addrs, RegionSize)
SB_SetText(" 미용지침서 2-23 드라마 스타일(Lv2) 쓰기", 1)
}
else if (코드 = "미용지침서 2-24 앙증 스타일(Lv2)") {
Addrs := 0x00590A00
RegionSize := 0x2048
target = 1A2D00590A30B86850E8D100590AE8458D00590A1AC559FFEA82DBE9C0C2A40020C99D004C0028C77CD000002900320076000000000000
executable := mem.executable(Addrs, RegionSize)
SB_SetText(" 미용지침서 2-24 앙증 스타일(Lv2) 쓰기", 1)
}
else if (코드 = "미용지침서 2-25 트윈테일 스타일(Lv2)") {
Addrs := 0x00590A00
RegionSize := 0x2048
target = 1A2D00590A34B86850E8D100590AE8458D00590A1AD2B8FFEA82DBE920C77CD14CC708C77CD0C0C2A400320076004C002800000000002900000000
executable := mem.executable(Addrs, RegionSize)
SB_SetText(" 미용지침서 2-25 트윈테일 스타일(Lv2) 쓰기", 1)
}
else if (코드 = "미용지침서 3-1 검은눈 성형(Lv3)") {
Addrs := 0x00590A00
RegionSize := 0x2048
target = 1A2D00590A30B86850E8D100590AE8458D00590A1AAC80FFEA82DBE9310020B208C740004C0028D615C100002900330076000000000000
executable := mem.executable(Addrs, RegionSize)
SB_SetText(" 미용지침서 3-1 검은눈 성형(Lv3) 쓰기", 1)
}
else if (코드 = "미용지침서 3-2 파란눈 성형(Lv3)") {
Addrs := 0x00590A00
RegionSize := 0x2048
target = 1A2D00590A30B86850E8D100590AE8458D00590A1AD30CFFEA82DBE9310020B208B780004C0028D615C100002900330076000000000000
executable := mem.executable(Addrs, RegionSize)
SB_SetText(" 미용지침서 3-2 파란눈 성형(Lv3) 쓰기", 1)
}
else if (코드 = "미용지침서 3-3 찢어진눈 성형(Lv3)") {
Addrs := 0x00590A00
RegionSize := 0x2048
target = 1A2D00590A32B86850E8D100590AE8458D00590A1ACC22FFEA82DBE920B208C9C4C5B40028D615C131002900330076004C0000000000000000
executable := mem.executable(Addrs, RegionSize)
SB_SetText(" 미용지침서 3-3 찢어진눈 성형(Lv3) 쓰기", 1)
}
else if (코드 = "목공지침서 1-1 소나무 가공(Lv1)") {
Addrs := 0x00590A00
RegionSize := 0x2048
target = 1A2D00590A30B86850E8D100590AE8458D00590A1AC18CFFEA82DBE9000020BB34B098004C0028ACF5AC00002900310076000000000000
executable := mem.executable(Addrs, RegionSize)
SB_SetText(" 목공지침서 1-1 소나무 가공(Lv1) 쓰기", 1)
}
else if (코드 = "목공지침서 1-2 단풍나무 가공(Lv1)") {
Addrs := 0x00590A00
RegionSize := 0x2048
target = 1A2D00590A32B86850E8D100590AE8458D00590A1AB2E8FFEA82DBE920BB34B098D48D0028ACF5AC00002900310076004C0000000000000000
executable := mem.executable(Addrs, RegionSize)
SB_SetText(" 목공지침서 1-2 단풍나무 가공(Lv1) 쓰기", 1)
}
else if (코드 = "목공지침서 1-3 참나무 가공(Lv1)") {
Addrs := 0x00590A00
RegionSize := 0x2048
target = 1A2D00590A30B86850E8D100590AE8458D00590A1ACC38FFEA82DBE9000020BB34B098004C0028ACF5AC00002900310076000000000000
executable := mem.executable(Addrs, RegionSize)
SB_SetText(" 목공지침서 1-3 참나무 가공(Lv1) 쓰기", 1)
}
else if (코드 = "목공지침서 1-4 대나무 가공(Lv1)") {
Addrs := 0x00590A00
RegionSize := 0x2048
target = 1A2D00590A30B86850E8D100590AE8458D00590A1AB300FFEA82DBE9000020BB34B098004C0028ACF5AC00002900310076000000000000
executable := mem.executable(Addrs, RegionSize)
SB_SetText(" 목공지침서 1-4 대나무 가공(Lv1) 쓰기", 1)
}
else if (코드 = "목공지침서 2-1 토끼조각상 조각(Lv2)") {
Addrs := 0x00590A00
RegionSize := 0x2048
target = 1A2D00590A34B86850E8D100590AE8458D00590A1AD1A0FFEA82DBE9C1AC01C870B07CAC01C8700020C0320076004C002800000000002900000000
executable := mem.executable(Addrs, RegionSize)
SB_SetText(" 목공지침서 2-1 토끼조각상 조각(Lv2) 쓰기", 1)
}
else if (코드 = "목공지침서 2-2 암탉조각상 조각(Lv2)") {
Addrs := 0x00590A00
RegionSize := 0x2048
target = 1A2D00590A34B86850E8D100590AE8458D00590A1AC554FFEA82DBE9C1AC01C870D0C9AC01C8700020C0320076004C002800000000002900000000
executable := mem.executable(Addrs, RegionSize)
SB_SetText(" 목공지침서 2-2 암탉조각상 조각(Lv2) 쓰기", 1)
}
else if (코드 = "목공지침서 2-3 수탉조각상 조각(Lv2)") {
Addrs := 0x00590A00
RegionSize := 0x2048
target = 1A2D00590A34B86850E8D100590AE8458D00590A1AC218FFEA82DBE9C1AC01C870D0C9AC01C8700020C0320076004C002800000000002900000000
executable := mem.executable(Addrs, RegionSize)
SB_SetText(" 목공지침서 2-3 수탉조각상 조각(Lv2) 쓰기", 1)
}
else if (코드 = "목공지침서 2-4 푸푸조각상 조각(Lv2)") {
Addrs := 0x00590A00
RegionSize := 0x2048
target = 1A2D00590A34B86850E8D100590AE8458D00590A1AD478FFEA82DBE9C1AC01C870D478AC01C8700020C0320076004C002800000000002900000000
executable := mem.executable(Addrs, RegionSize)
SB_SetText(" 목공지침서 2-4 푸푸조각상 조각(Lv2) 쓰기", 1)
}
else if (코드 = "목공지침서 3-1 토끼상자 조각(Lv3)") {
Addrs := 0x00590A00
RegionSize := 0x2048
target = 1A2D00590A32B86850E8D100590AE8458D00590A1AD1A0FFEA82DBE920C790C0C1B07C0028AC01C870002900330076004C0000000000000000
executable := mem.executable(Addrs, RegionSize)
SB_SetText(" 목공지침서 3-1 토끼상자 조각(Lv3) 쓰기", 1)
}
else if (코드 = "목공지침서 3-2 푸푸상자 조각(Lv3)") {
Addrs := 0x00590A00
RegionSize := 0x2048
target = 1A2D00590A32B86850E8D100590AE8458D00590A1AD478FFEA82DBE920C790C0C1D4780028AC01C870002900330076004C0000000000000000
executable := mem.executable(Addrs, RegionSize)
SB_SetText(" 목공지침서 3-2 푸푸상자 조각(Lv3) 쓰기", 1)
}
else if (코드 = "목공지침서 3-3 오크상자 조각(Lv3)") {
Addrs := 0x00590A00
RegionSize := 0x2048
target = 1A2D00590A32B86850E8D100590AE8458D00590A1AC624FFEA82DBE920C790C0C1D06C0028AC01C870002900330076004C0000000000000000
executable := mem.executable(Addrs, RegionSize)
SB_SetText(" 목공지침서 3-3 오크상자 조각(Lv3) 쓰기", 1)
}
else if (코드 = "목공지침서 3-4 고블린상자 조각(Lv3)") {
Addrs := 0x00590A00
RegionSize := 0x2048
target = 1A2D00590A34B86850E8D100590AE8458D00590A1AACE0FFEA82DBE990C0C1B9B0BE14AC01C8700020C7330076004C002800000000002900000000
executable := mem.executable(Addrs, RegionSize)
SB_SetText(" 목공지침서 3-4 고블린상자 조각(Lv3) 쓰기", 1)
}
else if (코드 = "목공지침서 4-1 뗏목 제작(Lv4)") {
Addrs := 0x00590A00
RegionSize := 0x2048
target = 1A2D00590A2EB86850E8D100590AE8458D00590A1AB5CFFFEA82DBE991C81C0020BAA90076004C0028C70000000029003400000000
executable := mem.executable(Addrs, RegionSize)
SB_SetText(" 목공지침서 4-1 뗏목 제작(Lv4) 쓰기", 1)
}
else if (코드 = "목공지침서 4-2 나무보트 제작(Lv4)") {
Addrs := 0x00590A00
RegionSize := 0x2048
target = 1A2D00590A32B86850E8D100590AE8458D00590A1AB098FFEA82DBE920D2B8BCF4BB340028C791C81C002900340076004C0000000000000000
executable := mem.executable(Addrs, RegionSize)
SB_SetText(" 목공지침서 4-2 나무보트 제작(Lv4) 쓰기", 1)
}
else if (코드 = "목공지침서 5-1 스노우보드 제작(Lv5)") {
Addrs := 0x00590A00
RegionSize := 0x2048
target = 1A2D00590A34B86850E8D100590AE8458D00590A1AC2A4FFEA82DBE9DCBCF4C6B0B178C791C81C0020B4350076004C002800000000002900000000
executable := mem.executable(Addrs, RegionSize)
SB_SetText(" 목공지침서 5-1 스노우보드 제작(Lv5) 쓰기", 1)
}
else if (코드 = "목공지침서 5-2 썰매 제작(Lv5)") {
Addrs := 0x00590A00
RegionSize := 0x2048
target = 1A2D00590A2EB86850E8D100590AE8458D00590A1AC370FFEA82DBE991C81C0020B9E40076004C0028C70000000029003500000000
executable := mem.executable(Addrs, RegionSize)
SB_SetText(" 목공지침서 5-2 썰매 제작(Lv5) 쓰기", 1)
}
else if (코드 = "연금술지침서 1-1 힐링포션 제작(Lv1)") {
Addrs := 0x00590A00
RegionSize := 0x2048
target = 1A2D00590A32B86850E8D100590AE8458D00590A1AD790FFEA82DBE920C158D3ECB9C10028C791C81C002900310076004C0000000000000000
executable := mem.executable(Addrs, RegionSize)
SB_SetText(" 연금술지침서 1-1 힐링포션 제작(Lv1) 쓰기", 1)
}
else if (코드 = "연금술지침서 1-2 마나포션 제작(Lv1)") {
Addrs := 0x00590A00
RegionSize := 0x2048
target = 1A2D00590A32B86850E8D100590AE8458D00590A1AB9C8FFEA82DBE920C158D3ECB0980028C791C81C002900310076004C0000000000000000
executable := mem.executable(Addrs, RegionSize)
SB_SetText(" 연금술지침서 1-2 마나포션 제작(Lv1) 쓰기", 1)
}
else if (코드 = "연금술지침서 1-3 단검용독 제작(Lv1)") {
Addrs := 0x00590A00
RegionSize := 0x2048
target = 1A2D00590A32B86850E8D100590AE8458D00590A1AB2E8FFEA82DBE920B3C5C6A9AC800028C791C81C002900310076004C0000000000000000
executable := mem.executable(Addrs, RegionSize)
SB_SetText(" 연금술지침서 1-3 단검용독 제작(Lv1) 쓰기", 1)
}
else if (코드 = "연금술지침서 2-1 스피드포션(1ml) 제작(Lv2)") {
Addrs := 0x00590A00
RegionSize := 0x2048
target = 1A2D00590A3EB86850E8D100590AE8458D00590A1AC2A4FFEA82DBE958D3ECB4DCD53C006D00310028C11C00200029006C004C0028C791C800002900320076000000000000
executable := mem.executable(Addrs, RegionSize)
SB_SetText(" 연금술지침서 2-1 스피드포션(1ml) 제작(Lv2) 쓰기", 1)
}
else if (코드 = "연금술지침서 2-2 스피드포션(2ml) 제작(Lv2)") {
Addrs := 0x00590A00
RegionSize := 0x2048
target = 1A2D00590A3EB86850E8D100590AE8458D00590A1AC2A4FFEA82DBE958D3ECB4DCD53C006D00320028C11C00200029006C004C0028C791C800002900320076000000000000
executable := mem.executable(Addrs, RegionSize)
SB_SetText(" 연금술지침서 2-2 스피드포션(2ml) 제작(Lv2) 쓰기", 1)
}
else if (코드 = "연금술지침서 2-3 스피드포션(3ml) 제작(Lv2)") {
Addrs := 0x00590A00
RegionSize := 0x2048
target = 1A2D00590A3EB86850E8D100590AE8458D00590A1AC2A4FFEA82DBE958D3ECB4DCD53C006D00330028C11C00200029006C004C0028C791C800002900320076000000000000
executable := mem.executable(Addrs, RegionSize)
SB_SetText(" 연금술지침서 2-3 스피드포션(3ml) 제작(Lv2) 쓰기", 1)
}
else if (코드 = "연금술지침서 2-4 스피드포션(4ml) 제작(Lv2)") {
Addrs := 0x00590A00
RegionSize := 0x2048
target = 1A2D00590A3EB86850E8D100590AE8458D00590A1AC2A4FFEA82DBE958D3ECB4DCD53C006D00340028C11C00200029006C004C0028C791C800002900320076000000000000
executable := mem.executable(Addrs, RegionSize)
SB_SetText(" 연금술지침서 2-4 스피드포션(4ml) 제작(Lv2) 쓰기", 1)
}
else if (코드 = "연금술지침서 2-5 스피드포션(5ml) 제작(Lv2)") {
Addrs := 0x00590A00
RegionSize := 0x2048
target = 1A2D00590A3EB86850E8D100590AE8458D00590A1AC2A4FFEA82DBE958D3ECB4DCD53C006D00350028C11C00200029006C004C0028C791C800002900320076000000000000
executable := mem.executable(Addrs, RegionSize)
SB_SetText(" 연금술지침서 2-5 스피드포션(5ml) 제작(Lv2) 쓰기", 1)
}
else if (코드 = "연금술지침서 2-6 스피드포션(6ml) 제작(Lv2)") {
Addrs := 0x00590A00
RegionSize := 0x2048
target = 1A2D00590A3EB86850E8D100590AE8458D00590A1AC2A4FFEA82DBE958D3ECB4DCD53C006D00360028C11C00200029006C004C0028C791C800002900320076000000000000
executable := mem.executable(Addrs, RegionSize)
SB_SetText(" 연금술지침서 2-6 스피드포션(6ml) 제작(Lv2) 쓰기", 1)
}
else if (코드 = "연금술지침서 2-7 체력향상포션(1ml) 제작(Lv2)") {
Addrs := 0x00590A00
RegionSize := 0x2048
target = 1A2D00590A40B86850E8D100590AE8458D00590A1ACCB4FFEA82DBE9ECC0C1D5A5B82500310028C158D3200029006C006D0028C791C81C002900320076004C0000000000000000
executable := mem.executable(Addrs, RegionSize)
SB_SetText(" 연금술지침서 2-7 체력향상포션(1ml) 제작(Lv2) 쓰기", 1)
}
else if (코드 = "연금술지침서 2-8 체력향상포션(2ml) 제작(Lv2)") {
Addrs := 0x00590A00
RegionSize := 0x2048
target = 1A2D00590A40B86850E8D100590AE8458D00590A1ACCB4FFEA82DBE9ECC0C1D5A5B82500320028C158D3200029006C006D0028C791C81C002900320076004C0000000000000000
executable := mem.executable(Addrs, RegionSize)
SB_SetText(" 연금술지침서 2-8 체력향상포션(2ml) 제작(Lv2) 쓰기", 1)
}
else if (코드 = "연금술지침서 2-9 체력향상포션(3ml) 제작(Lv2)") {
Addrs := 0x00590A00
RegionSize := 0x2048
target = 1A2D00590A40B86850E8D100590AE8458D00590A1ACCB4FFEA82DBE9ECC0C1D5A5B82500330028C158D3200029006C006D0028C791C81C002900320076004C0000000000000000
executable := mem.executable(Addrs, RegionSize)
SB_SetText(" 연금술지침서 2-9 체력향상포션(3ml) 제작(Lv2) 쓰기", 1)
}
else if (코드 = "연금술지침서 2-10 체력향상포션(4ml) 제작(Lv2)") {
Addrs := 0x00590A00
RegionSize := 0x2048
target = 1A2D00590A40B86850E8D100590AE8458D00590A1ACCB4FFEA82DBE9ECC0C1D5A5B82500340028C158D3200029006C006D0028C791C81C002900320076004C0000000000000000
executable := mem.executable(Addrs, RegionSize)
SB_SetText(" 연금술지침서 2-10 체력향상포션(4ml) 제작(Lv2) 쓰기", 1)
}
else if (코드 = "연금술지침서 2-11 체력향상포션(5ml) 제작(Lv2)") {
Addrs := 0x00590A00
RegionSize := 0x2048
target = 1A2D00590A40B86850E8D100590AE8458D00590A1ACCB4FFEA82DBE9ECC0C1D5A5B82500350028C158D3200029006C006D0028C791C81C002900320076004C0000000000000000
executable := mem.executable(Addrs, RegionSize)
SB_SetText(" 연금술지침서 2-11 체력향상포션(5ml) 제작(Lv2) 쓰기", 1)
}
else if (코드 = "연금술지침서 2-12 체력향상포션(6ml) 제작(Lv2)") {
Addrs := 0x00590A00
RegionSize := 0x2048
target = 1A2D00590A40B86850E8D100590AE8458D00590A1ACCB4FFEA82DBE9ECC0C1D5A5B82500360028C158D3200029006C006D0028C791C81C002900320076004C0000000000000000
executable := mem.executable(Addrs, RegionSize)
SB_SetText(" 연금술지침서 2-12 체력향상포션(6ml) 제작(Lv2) 쓰기", 1)
}
else if (코드 = "연금술지침서 3-1 주괴 제작(Lv3)") {
Addrs := 0x00590A00
RegionSize := 0x2048
target = 1A2D00590A2EB86850E8D100590AE8458D00590A1AC8FCFFEA82DBE991C81C0020AD340076004C0028C70000000029003300000000
executable := mem.executable(Addrs, RegionSize)
SB_SetText(" 연금술지침서 3-1 주괴 제작(Lv3) 쓰기", 1)
}
;Process finished with exit code 0
ContentLength := StrLen(target)
LoopCount := ContentLength // 14
LastLoopLength := ContentLength - (LoopCount * 14)
if (LastLoopLength > 0)
{
LoopCount := LoopCount + 1
}
Loop, % LoopCount
{
A := SubStr(target, 1, 14)
C := Substr(target, 15)
target := C
mem.write7bytes(Addrs, "0x"A)
Addrs := Addrs+7
}
return
}

get_player_id(파티타겟이름)
{
	Start_Scan := 0
	player_id := 0
	WinGet, temp_pid, PID, %파티타겟이름%
	ProcHwnd := DllCall("OpenProcess", "Int", 24, "Char", 0, "UInt", temp_pid, "UInt")
	DllCall("ReadProcessMemory","UInt",ProcHwnd,"UInt",0x0058DAD4,"Str",Start_Scan,"UInt",4,"UInt *",0)
	Loop 4
	result += *(&Start_Scan + A_Index-1) << 8*(A_Index-1)
	result := result+98
	DllCall("ReadProcessMemory","UInt",ProcHwnd,"UInt",result,"Str",Start_Scan,"UInt",4,"UInt *",0)
	Loop 4
	player_id += *(&Start_Scan + A_Index-1) << 8*(A_Index-1)
	DllCall("CloseHandle", "int", ProcHwnd)
	Return, player_id
}

RefleshPartyWindowList(TitleNumber)
{
	jElanciaArray := []
	Winget, jElanciaArray, List, ahk_class Nexon.Elancia
	GuiControl,, %A_Index%번캐릭터명,
	Loop, %jElanciaArray%
	{
		jElancia := jElanciaArray%A_Index%
		WinGetTitle,Title,ahk_id %jElancia%
		GuiControl,, %A_Index%번캐릭터명, %Title%
	}
}

Perfect()
{
	mem.write(0x004cfbc5,0xa2,"char",aOffset*)
	mem.write(0x004d05cd,0xa2,"char",aOffset*)
}

Normal()
{
	mem.write(0x004cfbc5,0xb6,"char",aOffset*)
	mem.write(0x004d05cd,0xb6,"char",aOffset*)
}

Miss()
{
	mem.write(0x004cfbc5,0xb2,"char",aOffset*)
	mem.write(0x004d05cd,0xb2,"char",aOffset*)
}

Attack_Motion()
{
	mem.write(0x0047C1A9,0x6A,"char",aOffset*)
	mem.write(0x0047C1AA,0x00,"char",aOffset*)
	mem.write(0x0047C1AB,0x90,"char",aOffset*)
	mem.write(0x0047C1AC,0x90,"char",aOffset*)
	mem.write(0x0047C1AD,0x90,"char",aOffset*)
}

ride_enable()
{
	mem.write(0x0046035B,0x90,"char",aOffset*)
	mem.write(0x0046035C,0x90,"char",aOffset*)
	mem.write(0x0046035D,0x90,"char",aOffset*)
	mem.write(0x0046035E,0x90,"char",aOffset*)
	mem.write(0x0046035F,0x90,"char",aOffset*)
	mem.write(0x00460360,0x90,"char",aOffset*)
}

ride_disable()
{
	mem.write(0x0046035B,0x89,"char",aOffset*)
	mem.write(0x0046035C,0x83,"char",aOffset*)
	mem.write(0x0046035D,0x6B,"char",aOffset*)
	mem.write(0x0046035E,0x01,"char",aOffset*)
	mem.write(0x0046035F,0x00,"char",aOffset*)
	mem.write(0x00460360,0x00,"char",aOffset*)
}

메모리실행(코드)
{
SetFormat, Integer, H
sb_settext(코드, 3)

Run_Thread := 0
if (코드 = "은행넣기")  {
Run_Thread := 1
Addrs := 0x00590005
}
else if (코드 = "은행빼기")  {
Run_Thread := 1
Addrs := 0x00590251
}
else if (코드 = "하나씩소각")  {
Run_Thread := 1
Addrs := 0x00590097
}
else if (코드 = "무기탈거")  {
Run_Thread := 1
Addrs := 0x0058D250
}
else if (코드 = "스킬사용")  {
Run_Thread := 1
Addrs := 0x0058D600
}
else if (코드 = "마법사용")  {
Run_Thread := 1
Addrs := 0x00590200
}
else if (코드 = "타겟스킬사용")  {
Run_Thread := 1
Addrs := 0x0058FF00
}
else if (코드 = "파티걸기") {
Run_Thread := 1
Addrs := 0x0058FE00
}
else if (코드 = "NPC호출") {
Run_Thread := 1
Addrs := 0x00527B4C
}
else if (코드 = "따라가기") {
Run_Thread := 1
Addrs := 0x00590740
}
else if (코드 = "공격하기") {
Run_Thread := 1
Addrs := 0x00590700
}
else if (코드 = "좌표이동") {
Run_Thread := 1
Addrs := 0x00590620
}
else if (코드 = "퀵슬롯사용") {
Run_Thread := 1
Addrs := 0x005279CC
}
else if (코드 = "섭팅하기") {
Run_Thread :=
Addrs :=
}
if (Run_Thread = 1) {
useskill := RunThread(Addrs)
}
SetFormat, Integer, D
}

마법사용(마법이름, 대상)
{
	Gui,ListView,마법리스트
	마법번호 := 0
	마법대상 := 0
	SetFormat, Integer, H
	if (대상 = "자신")
	{
		마법대상 := mem.read(0x0058DAD4, "UInt", 0x62)
	}
	else if (대상 = "클릭된대상")
	{
		마법대상 := mem.read(0x00584C2C, "UInt", aOffsets*)
	}
	else
	{
		마법대상 := 대상
	}
	Loop % LV_GetCount()
	{
		LV_GetText(spell_name, A_Index, 3)
		if (spell_name = 마법이름)
			마법번호 := A_Index
	}
	if (마법번호 != 0 && 마법대상!= 0)
	{
		메모리권한변경및쓰기("마법호출")
		mem.write(0x0059023A, 마법번호, "UInt", aOffsets*)
		mem.write(0x0059023B, 마법대상, "UInt", aOffsets*)
		sleep,10
		메모리실행("마법사용")
	}
	SetFormat, Integer, D
}

타겟스킬사용(타겟스킬이름, 대상)
{
	gui,listview,몬스터리스트
	몬스터리스트선택 := LV_GetNext(0)
	if (몬스터리스트선택 = 0)
	{
	}
	else
	{
		Gui,ListView,어빌리티리스트
		타겟스킬번호 := 0
		타겟스킬대상 := 0
		SetFormat, Integer, H
		if (대상 = "자신")
		{
			타겟스킬대상 := mem.read(0x0058DAD4, "UInt", 0x62)
		}
		else if (대상 = "클릭된대상")
			타겟스킬대상 := mem.read(0x00584C2C, "UInt", aOffsets*)

		Loop % LV_GetCount()
		{
			LV_GetText(skill_name, A_Index, 3)
			if (skill_name = 타겟스킬이름)
			타겟스킬번호 := A_Index
		}
		SB_SETTEXT(타겟스킬이름 ", " 타겟스킬번호 , 3)
		if (타겟스킬번호 != 0 && 타겟스킬대상!= 0)
		{
			메모리권한변경및쓰기("타겟스킬호출")
			mem.write(0x0058FF3A, 타겟스킬번호, "char", aOffsets*)
			mem.write(0x0058FF3B, 타겟스킬대상, "UInt", aOffsets*)
			sleep,10
			메모리실행("타겟스킬사용")
		}
		SetFormat, Integer, D
	}
}


;-------------------------------------------------------
;-------단발성 실행 코드---------------------------------
;-------------------------------------------------------

라깃구매: ;자사용
{
Buy_Unlimitted()
loop,
{
	맵번호 := mem.read(0x0058EB1C, "UInt", 0x10E)
	좌표X := mem.read(0x0058DAD4, "UInt", 0x10)
	좌표Y := mem.read(0x0058DAD4, "UInt", 0x14)
	좌표Z := mem.read(0x0058DAD4, "UInt", 0x18)
	if !(맵번호 = 2 || 맵번호 = 1002 || 맵번호 = 2002 || 맵번호 = 3002 || 맵번호 = 4002 || 맵번호 = 219 || 맵번호 = 1219 || 맵번호 = 2219 || 맵번호 = 3219 || 맵번호 = 4219)
	{
		SB_SetText("마을에서 시작해야함",2)
		return
	}

	if (맵번호 = 2 || 맵번호 = 1002 || 맵번호 = 2002 || 맵번호 = 3002 || 맵번호 = 4002)
	{
		Ras_step := 1
	}
	else if (맵번호 = 219 || 맵번호 = 1219 || 맵번호 = 2219 || 맵번호 = 3219 || 맵번호 = 4219)
	{
		Ras_step := 2
	}

	gosub, 아이템읽어오기

	if (라스의깃갯수 >= 20 && 오란의깃갯수 >= 100)
	{
		if (맵번호 = 219 || 맵번호 = 1219 || 맵번호 = 2219 || 맵번호 = 3219 || 맵번호 = 4219)
		{
			Ras_step := 3
			SB_SetText("라깃 & 오깃 갯수가 충분함",2)
		}
		else
		{
			SB_SetText("라깃 & 오깃 갯수가 충분함",2)
			return
		}
	}

	if (Ras_step = 1)
	{
		SB_SetText("마법상점으로이동중",2)
		IsMoving := mem.read(0x0058EB1C, "UInt", 0x174)
		if (IsMoving = 0)
		{
			if (맵번호 = 2)
				좌표입력(201,119,1)
			else if (맵번호 = 1002)
				좌표입력(102,90,1)
			else if (맵번호 = 2002)
				좌표입력(73,64,0)
			else if (맵번호 = 3002)
				좌표입력(105,167,0)
			else if (맵번호 = 4002)
				좌표입력(135,119,1)
			SB_SetText("자동이동2",4)
			메모리실행("좌표이동")
			sleep, 1000
		}
	}

	if (Ras_step = 2)
	{
		SB_SetText("마법상점도착",2)
		if (맵번호 = 219)
		{
			NPC근처X := 54
			NPC근처Y := 27
		}
		if (맵번호 = 1219)
		{
			NPC근처X := 23
			NPC근처Y := 11
		}
		else if (맵번호 = 2219)
		{
			NPC근처X := 46
			NPC근처Y := 41
		}
		else if (맵번호 = 3219)
		{
			NPC근처X := 22
			NPC근처Y := 20
		}
		else if (맵번호 = 4219)
		{
			NPC근처X := 33
			NPC근처Y := 22
		}
		if (좌표x = NPC근처X && 좌표y = NPC근처Y)
		{
			KeyClick("AltR")
			sleep, 100
			SB_SetText("NPC호출중",2)
			if (맵번호 = 219)
			{
				NPC이름 := "에레노아"
			}
			else if (맵번호 = 1219)
			{
				NPC이름 := "카로에"
			}
			else if (맵번호 = 2219)
			{
				NPC이름 := "백작"
			}
			else if (맵번호 = 3219)
			{
				NPC이름 := "마데이아"
			}
			else if (맵번호 = 4219)
			{
				NPC이름 := "리노스"
			}
			loop, 5
			{
			NpcMenuSelection := mem.read(0x0058F0A4, "UInt", aOffset*)
			if (NpcMenuSelection = 0)
				CallNPC(NPC이름)
			else
				break
			sleep, 100
			}
			loop, 5
			{
				NPCMENUSELECT("Buy")
				sleep, 100
				if (Check_Shop("Buy")!=0)
					break
			}
			NPC거래창첫번째메뉴클릭()
			에레노아3 := "오란의깃"
			에레노아4 := "라스의깃"
			카로에1 := "오란의깃"
			카로에2 := "라스의깃"
			백작3 := "오란의깃"
			백작4 := "라스의깃"
			마데이아3 := "오란의깃"
			마데이아4 := "라스의깃"
			리노스4 := "오란의깃"
			리노스5 := "라스의깃"
			loop, 5
			{
				if Coin!=1
					break
				target := NPC이름 . A_Index
				target := %target%
				if (target = "오란의깃")
				{
					count := 100 - 오란의깃갯수
					if (count = 100)
					{
						keyclick("K1")
						keyclick("K0")
						keyclick("K0")
					}
					else if (count < 10)
					{
						key := "K"count
						keyclick(key)
					}
					else if (10 < count < 100)
					{
						TensDigit := Floor(count / 10)
						OnesDigit := count - TensDigit * 10
						key1 := "K"TensDigit
						key2 := "K"OnesDigit
						keyclick(key1)
						keyclick(key2)
					}
				}
				else if (target = "라스의깃")
				{
					count := 20 - 라스의깃갯수
					if (count = 100)
					{
						keyclick("K1")
						keyclick("K0")
						keyclick("K0")
					}
					else if (count < 10)
					{
						key := "K"count
						keyclick(key)
					}
					else if (10 < count < 100)
					{
						TensDigit := Floor(count / 10)
						OnesDigit := count - TensDigit * 10
						key1 := "K"TensDigit
						key2 := "K"OnesDigit
						keyclick(key1)
						keyclick(key2)
					}
				}
				keyclick("DownArrow")
				Now_Selected++
			}
			sleep,10
			NPC거래창OK클릭()
			sleep,1000
			NPC거래창닫기()
		}
		else if (IsMoving = 0)
		{
			SB_SetText("NPC한테가는중",2)
			좌표입력(NPC근처X,NPC근처Y,0)
			sleep,30
			SB_SetText("자동이동3",4)
			메모리실행("좌표이동")
			sleep, 500
		}

	}
	if (맵번호 = 2 || 맵번호 = 1002 || 맵번호 = 2002 || 맵번호 = 3002 || 맵번호 = 4002) && (Ras_step = 3)
		break
	if (Ras_step = 3)
	{
		SB_SetText("마법상점나가기",2)
		IsMoving := mem.read(0x0058EB1C, "UInt", 0x174)
		if (IsMoving = 0)
		{
			나가기X := 0
			나가기Y := 0
			if (맵번호 = 219)
			{
				나가기X := 54
				나가기Y := 43
			}
			if (맵번호 = 1219)
			{
				나가기X := 17
				나가기Y := 17
			}
			else if (맵번호 = 2219)
			{
				나가기X := 46
				나가기Y := 44
			}
			else if (맵번호 = 3219)
			{
				나가기X := 43
				나가기Y := 42
			}
			else if (맵번호 = 4219)
			{
				나가기X := 35
				나가기Y := 34
			}
			if (나가기X != 0 || 나가기Y != 0)
			{
				좌표입력(나가기X,나가기Y,0)
				sleep,10
				SB_SetText("자동이동3",4)
				메모리실행("좌표이동")
			}
			sleep, 1000
		}
	}
}
return
}

식빵구매: ;자사용
{
Buy_Unlimitted()
loop,
{
	맵번호 := mem.read(0x0058EB1C, "UInt", 0x10E)
	좌표X := mem.read(0x0058DAD4, "UInt", 0x10)
	좌표Y := mem.read(0x0058DAD4, "UInt", 0x14)
	좌표Z := mem.read(0x0058DAD4, "UInt", 0x18)
	if !(맵번호 = 2 || 맵번호 = 1002 || 맵번호 = 2002 || 맵번호 = 3002 || 맵번호 = 4002 || 맵번호 = 204 || 맵번호 = 1200 || 맵번호 = 2200 || 맵번호 = 3200 || 맵번호 = 4200)
	{
		SB_SetText("마을에서 시작해야함",2)
		return
	}

	if (맵번호 = 2 || 맵번호 = 1002 || 맵번호 = 2002 || 맵번호 = 3002 || 맵번호 = 4002)
	{
		Bread_step := 1
	}
	else if (맵번호 = 204 || 맵번호 = 1200 || 맵번호 = 2200 || 맵번호 = 3200 || 맵번호 = 4200)
	{
		Bread_step := 2
	}

	gosub, 아이템읽어오기

	if (식빵갯수 >= 181)
	{
		if (맵번호 = 204 || 맵번호 = 1200 || 맵번호 = 2200 || 맵번호 = 3200 || 맵번호 = 4200)
		{
			Bread_step := 3
			SB_SetText("식빵 갯수가 충분함",2)
		}
		else
		{
			SB_SetText("식빵 갯수가 충분함",2)
			return
		}
	}

	if (Bread_step = 1)
	{
		SB_SetText("식빵상점으로이동중",2)
		IsMoving := mem.read(0x0058EB1C, "UInt", 0x174)
		if (IsMoving = 0)
		{
			if (맵번호 = 2)
				좌표입력(121,215,1)
			else if (맵번호 = 1002)
				좌표입력(0,0,0)
			else if (맵번호 = 2002)
				좌표입력(0,0,0)
			else if (맵번호 = 3002)
				좌표입력(0,0,0)
			else if (맵번호 = 4002)
				좌표입력(49,83,1)
			SB_SetText("자동이동4",4)
			메모리실행("좌표이동")
			sleep, 1000
		}
	}

	if (Bread_step = 2)
	{
		SB_SetText("식빵상점도착",2)
		if (맵번호 = 204)
		{
			NPC근처X := 31
			NPC근처Y := 17
		}
		if (맵번호 = 1200)
		{
			NPC근처X := 0
			NPC근처Y := 0
		}
		else if (맵번호 = 2200)
		{
			NPC근처X := 0
			NPC근처Y := 0
		}
		else if (맵번호 = 3200)
		{
			NPC근처X := 0
			NPC근처Y := 0
		}
		else if (맵번호 = 4200)
		{
			NPC근처X := 32
			NPC근처Y := 30
		}

		if (좌표x = NPC근처X && 좌표y = NPC근처Y)
		{
			KeyClick("AltR")
			sleep, 100
			SB_SetText("NPC호출중",2)
			if (맵번호 = 204)
			{
				NPC이름 := "카딜라"
			}
			else if (맵번호 = 1200)
			{
				NPC이름 := ""
			}
			else if (맵번호 = 2200)
			{
				NPC이름 := ""
			}
			else if (맵번호 = 3200)
			{
				NPC이름 := ""
			}
			else if (맵번호 = 4200)
			{
				NPC이름 := "쿠키"
			}

			loop, 5
			{
			NpcMenuSelection := mem.read(0x0058F0A4, "UInt", aOffset*)
			if (NpcMenuSelection = 0)
				CallNPC(NPC이름)
			else
				break
			sleep, 100
			}
			loop, 5
			{
				NPCMENUSELECT("Buy")
				sleep, 100
				if (Check_Shop("Buy")!=0)
					break
			}
			NPC거래창첫번째메뉴클릭()
			쿠키28 := "식빵"
			loop, 29
			{
				if Coin!=1
					break
				target := NPC이름 . A_Index
				target := %target%
				if (target = "식빵")
				{
					keyclick("K1")
					keyclick("K0")
					keyclick("K0")
				}
				keyclick("DownArrow")
				Now_Selected++
			}
			loop, 10
			{
				sleep,200
				NPC거래창OK클릭()
				inven := mem.read(0x0058DAD4, "UInt", 0x178, 0xBE, 0x14)
				if (inven > 40)
				{
					break
				}
			}
			sleep,1000
			NPC거래창닫기()
		}
		else if (IsMoving = 0)
		{
			SB_SetText("NPC한테가는중",2)
			좌표입력(NPC근처X,NPC근처Y,0)
			sleep,30
			SB_SetText("자동이동5",4)
			메모리실행("좌표이동")
			sleep, 500
		}
	}
	if (맵번호 = 2 || 맵번호 = 1002 || 맵번호 = 2002 || 맵번호 = 3002 || 맵번호 = 4002) && (Bread_step = 3)
	{
		break
	}
	if (Bread_step = 3)
	{
		SB_SetText("식빵상점나가기",2)
		IsMoving := mem.read(0x0058EB1C, "UInt", 0x174)
		if (IsMoving = 0)
		{
			나가기X := 0
			나가기Y := 0
			if (맵번호 = 204)
			{
				나가기X := 25
				나가기Y := 42
			}
			if (맵번호 = 1200)
			{
				나가기X := 0
				나가기Y := 0
			}
			else if (맵번호 = 2200)
			{
				나가기X := 0
				나가기Y := 0
			}
			else if (맵번호 = 3200)
			{
				나가기X := 0
				나가기Y := 0
			}
			else if (맵번호 = 4200)
			{
				나가기X := 32
				나가기Y := 31
			}
			if (나가기X != 0 || 나가기Y != 0)
			{
				좌표입력(나가기X,나가기Y,0)
				sleep,10
				SB_SetText("자동이동6",4)
				메모리실행("좌표이동")
			}
			sleep, 1000
		}
	}
}
return
}

무기수리강제:
NeedRepair = 1
무기수리: ;자사용
{
repair_step := 1
loop,
{
	SB_SetText("무기수리루프시작",2)
	맵번호 := mem.read(0x0058EB1C, "UInt", 0x10E)
	좌표X := mem.read(0x0058DAD4, "UInt", 0x10)
	좌표Y := mem.read(0x0058DAD4, "UInt", 0x14)
	좌표Z := mem.read(0x0058DAD4, "UInt", 0x18)
	if !(맵번호 = 2 || 맵번호 = 1002 || 맵번호 = 2002 || 맵번호 = 3002 || 맵번호 = 4002 || 맵번호 = 213 || 맵번호 = 1213 || 맵번호 = 2213 || 맵번호 = 3213 || 맵번호 = 4213)
	{
		SB_SetText("마을에서 시작해야함",2)
		return
	}

	if (맵번호 = 2 || 맵번호 = 1002 || 맵번호 = 2002 || 맵번호 = 3002 || 맵번호 = 4002)
	{
		repair_step := 1
	}
	else if (맵번호 = 213 || 맵번호 = 1213 || 맵번호 = 2213 || 맵번호 = 3213 || 맵번호 = 4213)
	{
		repair_step := 2
	}

	if (NeedRepair = 0)
	{
		if (맵번호 = 213 || 맵번호 = 1213 || 맵번호 = 2213 || 맵번호 = 3213 || 맵번호 = 4213)
		{
			repair_step := 3
			SB_SetText("수리시도 완료함",2)
		}
		else
		{
			SB_SetText("수리시도 완료함",2)
			return
		}
	}

	if (repair_step = 1)
	{
		SB_SetText("수리상점으로이동중",2)
		IsMoving := mem.read(0x0058EB1C, "UInt", 0x174)
		if (IsMoving = 0)
		{
			if (맵번호 = 2)
				좌표입력(0,0,0)
			else if (맵번호 = 1002)
				좌표입력(0,0,0)
			else if (맵번호 = 2002)
				좌표입력(0,0,0)
			else if (맵번호 = 3002)
				좌표입력(0,0,0)
			else if (맵번호 = 4002)
				좌표입력(72,61,1)
			SB_SetText("자동이동7",4)
			메모리실행("좌표이동")
			sleep, 1000
		}
	}

	if (repair_step = 2)
	{
		SB_SetText("수리상점도착",2)
		if (맵번호 = 213)
		{
			NPC근처X := 0
			NPC근처Y := 0
		}
		if (맵번호 = 1213)
		{
			NPC근처X := 0
			NPC근처Y := 0
		}
		else if (맵번호 = 2213)
		{
			NPC근처X := 0
			NPC근처Y := 0
		}
		else if (맵번호 = 3213)
		{
			NPC근처X := 0
			NPC근처Y := 0
		}
		else if (맵번호 = 4213)
		{
			NPC근처X := 32
			NPC근처Y := 30
		}
		if (좌표x = NPC근처X && 좌표y = NPC근처Y)
		{
			KeyClick("AltR")
			sleep, 100
			SB_SetText("NPC호출중",2)
			if (맵번호 = 213)
			{
				NPC이름 := ""
			}
			else if (맵번호 = 1213)
			{
				NPC이름 := ""
			}
			else if (맵번호 = 2213)
			{
				NPC이름 := ""
			}
			else if (맵번호 = 3213)
			{
				NPC이름 := ""
			}
			else if (맵번호 = 4213)
			{
				NPC이름 := "키아"
			}
			Move_Repair()
			loop, 5
			{
			NpcMenuSelection := mem.read(0x0058F0A4, "UInt", aOffset*)
			if (NpcMenuSelection = 0)
				CallNPC(NPC이름)
			else
				break
			sleep, 100
			}
			loop, 5
			{
				NPCMENUSELECT("Repair")
				sleep, 100
				if (Check_Shop("Repair")!=0)
					break
			}
			NeedRepair := 0
			loop, 4
			{
				if (Check_Shop("Repair") != 0)
				{
					NPC거래창전체수리클릭()
					sleep, 300
					NPC거래창닫기()
				}
				else (Check_Shop("Repair") = 0 )
					break
			}
		}
		else if (IsMoving = 0)
		{
			SB_SetText("NPC한테가는중",2)
			좌표입력(NPC근처X,NPC근처Y,0)
			sleep,30
			SB_SetText("자동이동8",4)
			메모리실행("좌표이동")
			sleep, 500
		}

	}

	if (맵번호 = 2 || 맵번호 = 1002 || 맵번호 = 2002 || 맵번호 = 3002 || 맵번호 = 4002) && (repair_step = 3)
	{
		break
	}

	if (repair_step = 3)
	{
		맵번호 := mem.read(0x0058EB1C, "UInt", 0x10E)
		SB_SetText("수리상점나가기",2)
		IsMoving := mem.read(0x0058EB1C, "UInt", 0x174)
		if (IsMoving = 0)
		{
			나가기X := 0
			나가기Y := 0
			if (맵번호 = 213)
			{
				나가기X := 0
				나가기Y := 0
			}
			if (맵번호 = 1213)
			{
				나가기X := 0
				나가기Y := 0
			}
			else if (맵번호 = 2213)
			{
				나가기X := 0
				나가기Y := 0
			}
			else if (맵번호 = 3213)
			{
				나가기X := 0
				나가기Y := 0
			}
			else if (맵번호 = 4213)
			{
				나가기X := 32
				나가기Y := 31
			}
			if (나가기X != 0 && 나가기Y != 0)
			{
				좌표입력(나가기X,나가기Y,0)
				sleep,10
				SB_SetText("자동이동9",4)
				메모리실행("좌표이동")
			}
		sleep, 1000
		}
	}
	sleep,1000
}
return
}

데미지핵:
{
gui, submit, nohide
if (퍼펙트 = 1)
	Perfect()
else if (일반 = 1)
	Normal()
else if (미스 = 1)
	Miss()
return
}

파티캐릭터재확인: ;서포터용
{
IfWinExist, %ElanciaTitle%
{
	IfWinNotActive, %ElanciaTitle%
	{
		WinActivate,%ElanciaTitle%
	}
}
else
	Return
loop,10
{
	RefleshPartyWindowList(A_INDEX)
}
return
}

원격파티하기: ;서포터용
{
Gui, Submit, Nohide
loop, 10
{
	if( %A_Index%번캐릭터사용여부 = 1)
	{
		파티타겟이름 := %A_Index%번캐릭터명
		if(파티타겟이름!="")
		{
			Target_P_OID := get_player_id(파티타겟이름)
			mem.write(0x0058FE20, Target_P_OID, "UInt", aOffsets*)
			SB_SetText("파티걸기 - " 파티타겟이름,2)
			메모리실행("파티걸기")
		}

	}
}
return
}

포레스트네자동대화실행:
{
gui, submit, nohide
guicontrolget, 포레스트네자동대화실행중여부
if (포레스트네자동대화실행중여부 = "실행")
{
	Settimer, 포레스트네자동대화핵심코드, OFF
	if (포레스트네자동대화 != 1)
	GuiControl,, 포레스트네자동대화, 1
	GuiControl,, 포레스트네자동대화실행중여부, 중지
	gosub, 포레스트네자동대화핵심코드
	if (포레스트네자동대화딜레이 = "10분" )
		Timer := 10 * 60 * 1000
	else if (포레스트네자동대화딜레이 = "1분" )
		Timer := 1 * 60 * 1000
	else if (포레스트네자동대화딜레이 = "5분" )
		Timer := 5 * 60 * 1000
	else if (포레스트네자동대화딜레이 = "19분" )
		Timer := 19 * 60 * 1000
	Settimer, 포레스트네자동대화핵심코드, %Timer%
}
else if (포레스트네자동대화실행중여부 = "중지")
{
	Settimer, 포레스트네자동대화핵심코드, OFF
	GuiControl,, 포레스트네자동대화실행중여부, 실행
}
Return
}

무기바꾸기중지:
{
무바_Coin := 0
return
}

일랜시아시작: ; 스크립트 메인 루프
{
SetTimer,기타동작,off
SetTimer,메모리_주변검색, off
SetTimer,무기자동바꾸기,off
SetTimer,접속여부확인,off
setTimer,스킬사용,off
행깃교환Coin := 0

재접속횟수++
FormatTime, CurrentTime,, HH:mm  ; 현재 시간을 HH:mm 형식으로 가져옵니다.
guicontrol,, 재접속횟수기록, %재접속횟수%%CurrentTime%
IfWinExist, %TargetTitle%
{
ElanciaStep := 4
}
else
{
ElanciaStep := 1
}

Loop,
{
Gui,Submit,Nohide

If (ElanciaStep = 1)
{
IfWinNotExist, Elancia
{
ElanciaStep := 2
}
else
{
ElanciaStep := 3
}
}
Else If (ElanciaStep = 2)
{
SB_SetText("일랜실행", 4)
run, ngm://launch/ -mode:pluglaunch -game:74276 -locale:KR
Sleep, 10000
ElanciaStep := 3
}
Else If (ElanciaStep = 3)
{
SB_SetText("서버접속", 4)
ControlGetText, Patch, Static2, Elancia
sb_settext("서버메시지 - " Patch,2)
IfInString,Patch,일랜시아 서버에 연결할 수 없습니다.
{
SB_SetText("접속실패", 4)
WinKill, Elancia
sleep, 1000
ElanciaStep := 2
}
Else IfInString,Patch,게임을 시작하세요
{
sleep, 1000
WinGet,jPID,PID, Elancia
TargetPID := jPID
sb_settext("새프로그램ID - " jPID,2)
ControlSend, , {Enter}, Elancia
sleep, 6000
ElanciaStep := 4
}
Else
sleep, 1000
}
Else If (ElanciaStep = 4) ; 서버선택
{
SB_SetText("서버선택", 4)
sleep, 1000
keyclick("Enter")
mem := new _ClassMemory("ahk_pid " 0, "", hProcessCopy)
mem := new _ClassMemory("ahk_pid " TargetPID, "", hProcessCopy)
Server := mem.read(0x0058DAD0, "UChar", 0xC, 0x8, 0x8, 0x6C)
gosub, 기본메모리쓰기
if ( Server = 0 )
{
if (메인캐릭터서버 = "엘")
마우스클릭(299,248)
else if (메인캐릭터서버 = "테스")
마우스클릭(299,273)
ElanciaStep := 5
마우스클릭(365,384)
}
else
{
sleep, 100
}
sleep, 100
}
Else If (ElanciaStep = 5) ; 캐릭터선택
{
SB_SetText("캐릭선택", 4)
sleep, 5000
WinGetTitle, tempTitle, ahk_pid %TargetPID%
SB_SetText("캐릭선택" tempTitle, 4)
if(tempTitle = "일랜시아 - 엘" || tempTitle = "일랜시아 - 테스" || tempTitle = TargetTitle)
{
sleep, 1000
캐릭선택X := 460
캐릭선택Y := 184 + 18 * 메인캐릭터순서
마우스더블클릭(캐릭선택X,캐릭선택Y)
sleep, 5000
ElanciaStep := 6
}
else
{
sleep, 500
}
}
Else If (ElanciaStep = 6) ;접속여부 확인
{
SB_SetText("접속확인" tempTitle, 4)
WinGetTitle,newElanciaTitle,ahk_pid %TargetPID%
ServerConnectionCheck := mem.readString(0x0017E574, 40, "UTF-16", aOffsets*)
SB_SetText("newElanciaTitle:" newElanciaTitle, "TargetTitle:" TargetTitle, 2)
Server := jelan.read(0x0058DAD0, "UChar", 0xC, 0x10, 0x8, 0x36C)
인벤토리 := mem.read(0x0058DAD4, "UInt", 0x178, 0xBE, 0x14)
if(Server = 1)
{
IfInString,ServerConnectionCheck,서버와의 연결이
{
mem.writeString(0x0017E574, "", "UTF-16", aOffsets*)
SB_SetText(ServerConnectionCheck, 2)
sleep, 2000
keyclick("Enter")
ElanciaStep := 4
sleep, 5000
}
else IfInString,ServerConnectionCheck,오랜 시간 아무것도
{
mem.writeString(0x0017E574, "", "UTF-16", aOffsets*)
SB_SetText(ServerConnectionCheck, 2)
sleep, 2000
keyclick("Enter")
ElanciaStep := 5
sleep, 5000
}
else IfInString,ServerConnectionCheck,에어본
{
mem.writeString(0x0017E574, "", "UTF-16", aOffsets*)
SB_SetText(ServerConnectionCheck, 2)
sleep, 1000
keyclick("Enter")
ElanciaStep := 5
sleep, 5000
}
}
else if (인벤토리 > 0 && 인벤토리 <= 50)
{
SB_SetText("newElanciaTitle:" newElanciaTitle, "TargetTitle:" TargetTitle, 2)
ElanciaStep := "접속완료"
SB_SetText("접속완료",4)
SB_SetText("정상",1)
일랜시아점검필요 := False
gosub, 기본설정적용
break
}
if (newElanciaTitle = TargetTitle && Server = 0)
{
SB_SetText("newElanciaTitle:" newElanciaTitle, "TargetTitle:" TargetTitle, 2)
ElanciaStep := "접속완료"
SB_SetText("접속완료",4)
SB_SetText("정상",1)
일랜시아점검필요 := False
gosub, 기본설정적용
break
}
}
}
return
}

일랜시아선택:
{
Gui,Submit,Nohide
if (ElanciaTitle = "")
return
if (TargetTitle != "")
gosub, SaveBeforeExit
TargetTitle := ElanciaTitle
WinGet,jPID,PID,%TargetTitle%
TargetPID := jPID
mem := new _ClassMemory("ahk_pid " 0, "", hProcessCopy)
mem := new _ClassMemory("ahk_pid " jPID, "", hProcessCopy)
ThisWindowTitle := "일랜 - " . TargetTitle . ";"
Gui, Show, ,%ThisWindowTitle%
}
기본설정적용:
{
coin := 1
gosub, 기본메모리쓰기
gosub, 기본정보읽어오기
gosub, 어빌리티읽어오기
gosub, 마법읽어오기
gosub, Fill
gosub, ReloadGuiOptions
gosub, 아이템읽어오기
gosub, NPC리스트불러오기
gosub, 데미지핵
Gui, listview, 좌표리스트
LV_Delete()
LoadCoordData()


SetTimer,메모리_주변검색,400
SetTimer,접속여부확인,5000
SetTimer,기타동작,1000
SetTimer,무기자동바꾸기,333
setTimer,스킬사용, 1000
guicontrolget,시작시간
if (시작시간 = "시작시간")
{
guicontrol, ,현재TargetTitle, %TargetTitle%
지금시각 = %A_Now%
FormatTime, 지금시각_R, %지금시각%, yyyy 년 MM월 dd일 HH:mm
guicontrol, ,시작시간, %지금시각_R%
guicontrol, ,시작체력, %최대HP%
}
MapNumber :=  mem.read(0x0058EB1C, "UInt", 0x10E)
gui, submit, nohide
if (행깃구매여부 = 1 && MapNumber = 201)
	gosub 행운장매수
SB_SetText("정상",1)
if (포레스트네자동대화 = 1)
{
	guicontrol,,포레스트네자동대화실행중여부,실행
	gosub, 포레스트네자동대화실행
}
return
}

일랜시아새로고침:
{
Read_Elancia_Titles()
GuiControl,, ElanciaTitle, |
GuiControl,, ElanciaTitle, % ElanTitles
return
}

기본메모리쓰기:
{
Attack_Motion()
ride_enable()
Buy_Unlimitted()
메모리권한변경및쓰기("은행넣기결정코드")
메모리권한변경및쓰기("은행넣기실행코드")
메모리권한변경및쓰기("은행빼기코드")
메모리권한변경및쓰기("하나씩소각코드")
메모리권한변경및쓰기("아이템줍기코드")
메모리권한변경및쓰기("무기탈거")
메모리권한변경및쓰기("스킬사용")
메모리권한변경및쓰기("타겟스킬사용")
메모리권한변경및쓰기("타겟스킬호출")
메모리권한변경및쓰기("마법사용")
메모리권한변경및쓰기("마법호출")
;메모리권한변경및쓰기("섭팅하기코드")
메모리권한변경및쓰기("좌표이동")
메모리권한변경및쓰기("공격하기")
메모리권한변경및쓰기("따라가기")
메모리권한변경및쓰기("파티걸기")
메모리권한변경및쓰기("아이템줍기정지")
메모리권한변경및쓰기("퀵슬롯사용")
메모리권한변경및쓰기("몬스터주소기록함수")
sleep,100
메모리권한변경및쓰기("몬스터주소기록켜기")
;메모리권한변경및쓰기("아이템주소기록함수")
sleep,100
;메모리권한변경및쓰기("아이템주소기록켜기")
메모리권한변경및쓰기("플레이주소기록함수")
sleep,100
메모리권한변경및쓰기("플레이주소기록켜기")

mem.writeString(0x00590147, "물", "UTF-16", aOffsets*) ;소각할 아이템
mem.writeString(0x00590500, "물", "UTF-16", aOffsets*) ;은행에 넣을 아이템
mem.writeString(0x005901E5, "물", "UTF-16", aOffsets*) ;줍줍할 아이템

상승어빌주소 := mem.processPatternScan(0x00000000, 0x7FFFFFFF, 0xB0, 0x62, 0x53, 0x00, 0x01, 0x03, 0x00)
guicontrol, ,상승어빌주소, %상승어빌주소%
return

RunThread(Addrs) {
Gui,Submit,Nohide
PID := TargetPID

if (STOPSIGN = true)
{
	sb_Settext("STOPSIGN 으로인한 대기",2)
	sleep, 1000
	STOPSIGN := False
	sb_Settext("STOPSIGN 으로인한 대기끝",2)
}

RT_Delay := A_TickCount - RunThreadCounter
if (RT_Delay < 30)
{
	sleep, %RT_Delay%
}
RunThreadCounter := A_TickCount

인벤토리 := mem.read(0x0058DAD4, "UInt", 0x178, 0xBE, 0x14)
if(인벤토리 > 0 && 인벤토리 <= 50)
{
ProcHwnd := DllCall("OpenProcess", "UInt", 2035711, "Int", 0, "UInt", pid)
ThreadHandle := DllCall("CreateRemoteThread", "Ptr", ProcHwnd, "Ptr", 0, "UInt", 0, "Ptr", Addrs, "Ptr", 0, "UInt", 0, "PtrP", 0)

DllCall("CloseHandle", "Ptr", ThreadHandle)
if (!DllCall("CloseHandle", "Ptr", ProcHwnd)) {
SB_SetText("Error: Failed to close process handle.",2)
}
} else {
메모리권한변경및쓰기("아이템줍기정지")
메모리권한변경및쓰기("몬스터주소기록끄기")
;메모리권한변경및쓰기("아이템주소기록끄기")
메모리권한변경및쓰기("플레이주소기록끄기")
Coin := 0
무바_Coin := 0
SB_SetText("비정상",1)
return
}
}
}

기본정보읽어오기:
{
STR := mem.read(0x0058DAD4, "UInt", 0x178, 0x2F)
GuiControl,, STR, % STR

AGI := mem.read(0x0058DAD4, "UInt", 0x178, 0x3F)
GuiControl,, AGI, % AGI

INT := mem.read(0x0058DAD4, "UInt", 0x178, 0x33)
GuiControl,, INT, % INT

VIT := mem.read(0x0058DAD4, "UInt", 0x178, 0x3B)
GuiControl,, VIT, % VIT

FRAME := mem.read(0x0058DAD4, "UInt", 0x178, 0x47)
GuiControl,, FRAME, % FRAME

GALRID := mem.read(0x0058DAD4, "UInt", 0x178, 0x6F)
GuiControl,, GALRID, % GALRID

QUANTITY := mem.read(0x0058DAD4, "UInt", 0x178, 0xBE, 0x14)
GuiControl,, QUANTITY, % QUANTITY

VOTE := mem.read(0x0058DAD4, "UInt", 0x178, 0x4B)
GuiControl,, VOTE, % VOTE
return
}

일랜시아창크기구하기:
{
IfWinNotActive, %TargetTitle%
{
WinActivate,%TargetTitle%
sleep,1000
}
WinGetPos, OutX, OutY, OutWidth, OutHeight, A
Multiplyer := round(OutWidth/100,0)*100 / 800
if Multiplyer < 1
Multiplyer := 1
GuiControl,, Multiplyer, %Multiplyer%
return
}

좌표리스트실행:
{
gui,listview,좌표리스트
RN:=LV_GetNext(0)
if (rn=0)
return
Row := A_EventInfo
;번호|순번|맵이름|X|Y|Z
LV_GetText(E1,row,1)
LV_GetText(E2,row,2)
LV_GetText(E3,row,3)
LV_GetText(E4,row,4)
LV_GetText(E5,row,5)
LV_GetText(E6,row,6)
if (A_GuiEvent = "DoubleClick")
{
}
if A_GuiEvent = click
{
gui,listview, 좌표리스트
goto,좌표리스트추가메뉴
}
if A_GuiEvent = Rightclick
{
gui,listview, 좌표리스트
goto,좌표리스트추가메뉴
}
return
}

좌표리스트추가:
{
gui,listview,좌표리스트
좌표X := mem.read(0x0058DAD4, "UInt", 0x10)
좌표Y := mem.read(0x0058DAD4, "UInt", 0x14)
좌표Z := mem.read(0x0058DAD4, "UInt", 0x18)
맵번호 := mem.read(0x0058EB1C, "UInt", 0x10E)
맵이름 := mem.readString(mem.getModuleBaseAddress("jelancia_core.dll")+0x44A28, 50, "UTF-16", 0xC)

DB_RECORD_Coord(맵번호,맵이름,좌표X,좌표Y,좌표Z)
Gui, listview, 좌표리스트
LV_Delete()
LoadCoordData()
return

좌표리스트_DO:
gui, listview, 좌표리스트
If (A_ThisMenuItem = "이동하기")
gosub,좌표리스트_이동하기
If (A_ThisMenuItem = "수정하기")
gosub,좌표리스트_수정하기
If (A_ThisMenuItem = "삭제하기")
gosub,좌표리스트_삭제하기
return

좌표리스트_이동하기:
좌표입력(E4,E5,E6)
sleep,30
메모리실행("좌표이동")
return
}

좌표리스트_수정하기:
{
return
}

좌표리스트_삭제하기:
{
gui,listview,좌표리스트
RowNumber = 0
SelectRowNum := 0
loop
{
RowNumber := LV_GetNext(RowNumber)
if not RowNumber
break
SelectRowNum := RowNumber
}
LV_GetText(Mapnumber,SelectRowNum,1)
LV_GetText(MapName,SelectRowNum,2)
LV_GetText(x,SelectRowNum,4)
LV_GetText(y,SelectRowNum,5)
LV_GetText(z,SelectRowNum,6)
DB_RECORD_Delete(Mapnumber, MapName, x, y, z)
SB_SetText("좌표리스트삭제", 2)
Lv_Delete(SelectRowNum)
Return
}

NPC리스트실행:
{
gui,listview,NPC리스트
RN:=LV_GetNext(0)
if (rn=0)
	return
Row := A_EventInfo
맵번호 := mem.read(0x0058EB1C, "UInt", 0x10E)
차원 := Get_Dimension()
;분류|차원|맵이름|번호|이름|OID|X|Y|Z|우선순위|주소
LV_GetText(C1,row,1)
LV_GetText(C2,row,2)
LV_GetText(C3,row,3)
LV_GetText(C4,row,4)
LV_GetText(C5,row,5)
LV_GetText(C6,row,6)
LV_GetText(C7,row,7)
LV_GetText(C8,row,8)
LV_GetText(C9,row,9)
if (C2 != 차원 || C4 != 맵번호)
	return
CheckIfMyNPC := TargetTitle . "의"
ifinstring, C5, %CheckIfMyNPC%
{
좌표X := mem.read(0x0058DAD4, "UInt", 0x10)
좌표Y := mem.read(0x0058DAD4, "UInt", 0x14)
좌표Z := mem.read(0x0058DAD4, "UInt", 0x18)
distanceX := Abs(C7 - 좌표X)
distanceY := Abs(C8 - 좌표Y)
if (distanceX > 16 || distanceY > 7)
	return
}
if (A_GuiEvent = "DoubleClick")
{
	메모리권한변경및쓰기("NPC호출용1")
	메모리권한변경및쓰기("NPC호출용2")
	mem.write(0x00527b54, C6, "UInt", aOffset*)
	메모리실행("NPC호출")
}
if A_GuiEvent = click
	return
if A_GuiEvent = Rightclick
	return

return
}

중지:
{
Un_Freeze_Move()
Coin := 0
행깃교환Coin := 0
GuiControl,,행깃구매여부, 0
return
}

수리하기:
{
gui, listview, NPC리스트
if (Multiplyer = "없음" || Multiplyer < 1)
{
gosub, 일랜시아창크기구하기
sleep, 2000
}
맵번호 := mem.read(0x0058EB1C, "UInt", 0x10E)
차원 := Get_Dimension()
Loop, % LV_GetCount()
{
LV_GetText(NPC_차원, A_Index, 2)
LV_GetText(NPC_맵번호, A_Index, 4)
LV_GetText(NPC_이름, A_Index, 5)
LV_GetText(NPC_OID, A_Index, 6)
if (차원 = NPC_차원 && NPC_맵번호 = 맵번호) {
if (NPC_이름 = "실루엣" || NPC_이름 = "칸느" || NPC_이름 = "셀포이" || NPC_이름 = "키아" || NPC_이름 = "카멘" )
{
메모리권한변경및쓰기("NPC호출용1")
메모리권한변경및쓰기("NPC호출용2")
mem.write(0x00527b54, NPC_OID, "UInt", aOffset*)
메모리실행("NPC호출")
sleep, 100
Move_Repair()
sleep, 100
NPCMENUSELECT("Repair")
sleep, 100
loop, 4
{
if (Check_Shop("Repair") != 0)
{
NPC거래창전체수리클릭()
sleep, 300
NPC거래창닫기()
return
}
else (Check_Shop("Repair") = 0 )
sleep, 100
}

}
}
}

return
}

보조윈도우: ;YouTube 촬영용
{
Gui, 보조윈도우: +AlwaysOnTop +Resize +MinimizeBox +MaximizeBox
Gui, 보조윈도우: Default
; GUI 윈도우의 너비와 높이
GuiWidth := 32 * pixelsize ; 32 칸 * 각 칸의 너비 (20px)
GuiHeight := 18 * pixelsize ; 18 칸 * 각 칸의 높이 (20px)
Gui, 보조윈도우:Color, white
; 주인공의 초기 위치 (x와 y 좌표)
PlayerX := 16 * pixelsize ; 17번째 칸 * 각 칸의 너비 (20px)
PlayerY := 8 * pixelsize ; 9번째 칸 * 각 칸의 높이 (20px)

Gui, 보조윈도우: Add, Picture, x%PlayerX% y%PlayerY% w%pixelsize% h%pixelsize%  vMyChar, %greenimage%

; GUI 보이기
Gui, 보조윈도우:Show, w%GuiWidth% h%GuiHeight% Center, AHK 테스트용 게임

return
}
보조윈도우guiclose: ;YouTube 촬영용
{
Gui,보조윈도우: Destroy
IsGuiExist := []
return
}

NPC대화창으로방해하는지확인:
{
if (NPC_MSG_ADR = "없음" || NPC_MSG_ADR <1 )
NPC_MSG_ADR := Check_NPCMsg_address()
formNumber := Check_FormNumber()
if(formNumber == 40 || formNumber == 68){
loop, 3
{
keyclick("K6")
sleep, 10
}
formNumber := Check_FormNumber()
NPCMsg := Check_NPCMsg()
IfInString,NPCMsg,님께서
{
SB_SetText("방해확인됨" formNumber "-" NPCMsg ,2)
temp:=get_NPCTalk_cordi()
x:=temp.x - 10
y:=temp.y + 10
마우스클릭(x,y)
sleep, 100
마우스오른쪽버튼클릭(x,y)
}

}
return
}

게임내지침서사용:
{
메모리권한변경및쓰기("기존지침서사용")
return
}

핵지침서사용:
메모리권한변경및쓰기("기존지침서무시")
지침서선택:
{
gui, submit, nohide
guicontrolget, 지침서
메모리권한변경및쓰기(지침서)
return
}

넣을아이템입력:
{
gui, submit, nohide
guicontrolget,넣을아이템
은행넣을아이템 := mem.writeString(0x00590500, 넣을아이템, "UTF-16", aOffsets*)
return
}

은행넣기테스트:
{
메모리실행("은행넣기")
return
}

은행빼기테스트:
{
메모리실행("은행빼기")
return
}

마법읽어오기:
{
for Index, spell in SpellList
{
	%spell%번호 := 0
}
A:=0
Gui,ListView,마법리스트
LV_Delete()
loop,30
{
	A := 4 * A_index
	마법%A_index%_이름 := mem.readString(0x0058DAD4, 50, "UTF-16", 0x178, 0xc2, 0x8, A, 0x8, 0xC)
	마법%A_index% := mem.read(0x0058DAD4, "UInt", 0x178, 0xc2, 0x8, A, 0x8, 0x42C)
	마법이름 := 마법%A_index%_이름
	%마법이름%번호 := A_index
	레벨 := 마법%A_index%
	if(마법이름 != Fail && 마법이름 != "")
		LV_Add("", "마법", A_index, 마법이름, 0, 레벨)
	else
		break
}
return
}

어빌리티읽어오기:
{
for Index, skill in NormalSkillList
{
	%skill%번호 := 0
}
for Index, skill in TargetSkillList
{
	%skill%번호 := 0
}

A:=0
Gui,ListView,어빌리티리스트
LV_Delete()
loop,70
{
	A := 4 * A_index
	어빌리티%A_index%_이름 := mem.readString(0x0058DAD4, 50, "UTF-16", 0x178, 0xc6, 0x8, A, 0x8, 0x4)
	어빌리티%A_index%_그레이드 := mem.read(0x0058DAD4, "UInt", 0x178, 0xc6, 0x8, A, 0x8, 0x20c)
	어빌리티%A_index% := mem.read(0x0058DAD4, "UInt", 0x178, 0xc6, 0x8, A, 0x8, 0x208)
	어빌리티이름 := 어빌리티%A_index%_이름
	IfInString, 어빌리티이름,특수창
		어빌리티이름 := "창어빌"
	else IfInString, 어빌리티이름,해머
		어빌리티이름 := "봉어빌"
	%어빌리티이름%번호 := A_index
	그레이드 := 어빌리티%A_index%_그레이드
	어빌리티 := 어빌리티%A_index%
	어빌리티 := round(어빌리티/100,4)
	if(어빌리티이름 != Fail && 어빌리티이름 != "")
		LV_Add("", "어빌", A_index, 어빌리티이름, 그레이드, 어빌리티)
	else
		break
}
return
}

;-------------------------------------------------------
;-------반복성 실행 코드---------------------------------
;-------------------------------------------------------



포남링교환:
{
Gui, Submit, nohide
Coin := 1
if (Multiplyer = "없음" || Multiplyer < 1)
	gosub, 일랜시아창크기구하기
Player1Delay1 := A_TickCount
if (NPC_MSG_ADR = "없음" || NPC_MSG_ADR <1 )
	NPC_MSG_ADR := Check_NPCMsg_address()
Loop, 1
{
	Player%A_Index%Delay1 := A_TickCount
	Player%A_Index%NPCFORM := 0
	Player%A_Index%Step := 9
	Player%A_Index%success_rate :=0
	inven := mem.read(0x0058DAD4, "UInt", 0x178, 0xBE, 0x14)
	if(inven>49)
	{
	SB_SetText("인벤토리를 두칸정도 비우고 다시 시작해 주세요",2)
	coin := 0
	break
	}
}
loop,
{
	if Coin!=1
		break
	loop, 1
	{
		Step := Player%A_Index%Step
		success_rate := Player%A_Index%success_rate
		Gui, Submit, nohide
		if Coin!=1
			break
		else if (Player%A_Index%success_rate != 2)
		{
			currentplayer := A_Index
			sleep,1
			PREXC_Delay := A_TickCount - Player%A_Index%Delay1
			if (PREXC_Delay >= 500)
			{
				if Coin!=1
					break
				formNumber := Check_FormNumber()
				NPCMsg := Check_NPCMsg()
				SB_SetText("(" formNumber "/" step ")" NPCMsg , 2)
				sleep,1
				if(step=9)
					{
					Freeze_Move()
					if(formNumber != 81 &&formNumber != 85 && formNumber != 121)
					{
						loop,
						{
							Sleep,100
							formNumber := Check_FormNumber()
							if coin != 1
								break
							else if (formNumber = 81 || formNumber = 85 || formNumber = 121)
								break
						}
						loop,
						{
							formNumber := Check_FormNumber()
							sleep, 10
							if coin != 1
							break
							else if formNumber = 85
							{
								;생명의가루 교환
								x:=373
								y:=339
								마우스클릭(x,y)
								Player%A_Index%Step := 2
								sleep,1000
								break
							}
							else if formNumber = 121
							{
								Player%A_Index%Step := 2
								break
							}
						}
					}
					else if(formNumber != 0)
					{
						IfInString,NPCMsg,어디보자
						{
							temp:=get_NPCTalk_cordi()
							;[아이템과 바꾼다.] 위치
							x:=temp.x - 5
							y:=temp.y - 5
							마우스클릭(x,y)
							Player%A_Index%Step := 3
						}
						else IfInString,NPCMsg,30개 받을게
						{
							temp:=get_NPCTalk_cordi()
							;[예.] 위치
							x:=temp.x - 14
							y:=temp.y + 17
							마우스클릭(x,y)
							Player%A_Index%Step := 4
						}
						else IfInString,NPCMsg,모자란 것
						{
							KeyClick("K6")
							sleep,100
						}
						else IfInString,NPCMsg,미안한데 아이템은
						{
							KeyClick("K6")
							Player%A_Index%Step := 2
						}
						else IfInString,NPCMsg,가 나왔네
						{
							KeyClick("K6")
							Player%A_Index%Step := 2
						}
						else
						{
							sleep, 1
						}
					}

				}
				else if(step=2)
				{
					IfInString,NPCMsg,어디보자
					{
					temp:=get_NPCTalk_cordi()
					;[아이템과 바꾼다.] 위치
					x:=temp.x - 5
					y:=temp.y - 5
					마우스클릭(x,y)
					Player%A_Index%Step := 3
					}
				}
				else if(step=3)
				{
					IfInString,NPCMsg,받을게
					{
					temp:=get_NPCTalk_cordi()
					;[예.] 위치
					x:=temp.x - 14
					y:=temp.y + 17
					마우스클릭(x,y)
					Player%A_Index%Step := 4
					}
				}
				else if(step=4)
				{
					IfInString,NPCMsg,미안한데 아이템은
					{
						KeyClick("K6")
						sleep,10
						Player%A_Index%Step := 2
					}
					else IfInString,NPCMsg,가 나왔네
					{
						KeyClick("K6")
						sleep,10
						Player%A_Index%Step := 2
						success_rate++
					}
					else IfInString,NPCMsg,모자란 것
					{
						KeyClick("K6")
						sleep,10
						sb_settext("가루가 부족합니다! 작동을 중지합니다.",2)
						coin := 0
					}
				}
				Player%A_Index%Delay1 := A_TickCount
			}
		}

	}
}
Return
}

상인단순제작:
{
coin :=1
gui, submit, nohide
WinGet,pid,PID,%ElanciaTitle%
TargetPID := pid
처음시작 := 0
if (Multiplyer = "없음" || Multiplyer < 1)
gosub, 일랜시아창크기구하기
if (처음시작 = 0 && 성공실패주소 = 0)
{

메모리실행("무기탈거")
sleep, 100
책좌표X := mem.read(0x0058EB48, "UInt", 0xBC)
책좌표Y := mem.read(0x0058EB48, "UInt", 0xC0)
수련좌표X := 책좌표X + 80
수련좌표Y := 책좌표Y - 16
앙상블좌표X := 책좌표X - 76
앙상블좌표Y := 책좌표Y + 54
CoordMode, Pixel, Screen


마우스이동(수련좌표X,수련좌표Y)
sleep, 10
마우스클릭(수련좌표X,수련좌표Y)
sleep, 10
startAddress := 0x0F000000
endAddress := 0x4FFFFFFF
SetFormat, Integer, H
Result_Msg_Addr := mem.processPatternScan(address, endAddress, 0xE4, 0xC2, 0x28, 0xD3, 0x88, 0xD5, 0xB5, 0xC2, 0xC8, 0xB2, 0xE4, 0xB2, 0x44, 0xD5, 0x94, 0xC6) ;"실패했습니다필요" 검색
guicontrol, , Result_Msg_Addr, % Result_Msg_Addr
sleep, 10
SetFormat, Integer, D
sb_settext(Result_Msg_Addr,2)
if (Result_Msg_Addr>0)
{
goodtogo := 1
처음시작 := 1
Coin := 1
성공실패주소 := 1
SB_SetText("성공/실패 결과 주소 획득 성공"   ,1)
Keyclick(0)
}
else
{
SB_SetText("성공/실패 결과 주소 획득 실패, 매크로종료"   ,1)
COIN := 0
}
}
sleep, 1000
;메모리권한변경및쓰기("기존지침서무시")
;메모리권한변경및쓰기("기존지침서사용")
sleep, 1000

sleep, 1000
Cookdelay := 2800
loop,
{
if (Coin = 0)
break
sleep, 100
sleep, 100
책좌표X := mem.read(0x0058EB48, "UInt", 0xBC)
책좌표Y := mem.read(0x0058EB48, "UInt", 0xC0)
수련좌표X := 책좌표X + 80
수련좌표Y := 책좌표Y - 16
앙상블좌표X := 책좌표X - 76
앙상블좌표Y := 책좌표Y + 54

마우스이동(수련좌표X,수련좌표Y)
sleep, 10
마우스클릭(수련좌표X,수련좌표Y)
sleep, 100

loop, 10 ; 1초간 대기
{
if (Coin = 0)
break
sleep, 100
}
loop,  ; 0.5초마다 결과 확인
{
if (Coin = 0)
break
Read_Result_MSG := mem.readString(Result_Msg_Addr, 50, "UTF-16", aOffsets*)
ifinstring, Read_Result_MSG, 실패했습니다주세요.
{
Cookdelay := Cookdelay + 100
sleep, 2000
Write_Result_MSG := mem.writeString(Result_Msg_Addr, "", "UTF-16", aOffsets*)
마우스클릭(수련좌표X,수련좌표Y)
sleep, 100
SB_SetText("delay를 " Cookdelay " 로 재설정"   ,1)
}
else
{
break
}
sleep, 1000
}

Count_A := 0
Current_time := A_TickCount
loop,  ; 0.5초마다 결과 확인
{
if (Coin = 0)
break
Read_Result_MSG := mem.readString(Result_Msg_Addr, 50, "UTF-16", aOffsets*)
sb_settext(Read_Result_MSG,2)
ifinstring, Read_Result_MSG,에 성공
{
Write_Result_MSG := mem.writeString(Result_Msg_Addr, "", "UTF-16", aOffsets*)
break
}
else ifinstring, Read_Result_MSG,실패
{
Write_Result_MSG := mem.writeString(Result_Msg_Addr, "", "UTF-16", aOffsets*)
break
}
else ifinstring, Read_Result_MSG,부족합니다
{
Write_Result_MSG := mem.writeString(Result_Msg_Addr, "", "UTF-16", aOffsets*)
Coin := 0
break
}
else ifinstring, Read_Result_MSG,성향 포인트
{
Write_Result_MSG := mem.writeString(Result_Msg_Addr, "", "UTF-16", aOffsets*)
break
}
else ifinstring, Read_Result_MSG,경험치
{
Write_Result_MSG := mem.writeString(Result_Msg_Addr, "", "UTF-16", aOffsets*)
break
}
else ifinstring, Read_Result_MSG,향상
{
Write_Result_MSG := mem.writeString(Result_Msg_Addr, "", "UTF-16", aOffsets*)
break
}
if (A_TickCount - Current_time > 1000 )
{
Current_time := A_TickCount
Count_A += 1
SB_SetText("대기중" Count_A  ,1)
}
sleep, 1
if (Count_A > 11)
break
}


if (Coin = 0)
break

sleep, %Cookdelay%
}
return
}

상인어빌수련:
{
guicontrol, ,포레스트네자동대화, 0
guicontrol, ,자동공격여부, 0
guicontrol, ,자동이동여부, 0
guicontrol, ,아템먹기여부, 0
guicontrol, ,무기사용여부, 0

gui, submit, nohide
WinGet,pid,PID,%ElanciaTitle%
Freeze_Move()
TargetPID := pid
처음시작 := 0
RepairCount := 1
상승어빌이름주소 := 상승어빌주소 + 0x64
상승어빌값주소 := 상승어빌주소 + 0x264
상승어빌카운트주소 := 상승어빌주소 + 0x264 + 0x8
상승어빌 := mem.readString(상승어빌이름주소, 20, "UTF-16", aOffsets*)
상승어빌값 := mem.read(상승어빌값주소, "UInt", aOffsets*)
if (상승어빌 = "미용" || 상승어빌 = "요리" || 상승어빌 = "재단" || 상승어빌 = "스미스" || 상승어빌 = "세공" || 상승어빌 = "목공" || 상승어빌 = "연금술" )
{
상승어빌카운트 := mem.read(상승어빌카운트주소, "UShort", aOffsets*)
기존어빌카운트 := 상승어빌카운트
}
if (Multiplyer = "없음" || Multiplyer < 1)
gosub, 일랜시아창크기구하기
if (처음시작 = 0)
{
인벤토리 := mem.read(0x0058DAD4, "UInt", 0x178, 0xBE, 0x14)
if (인벤토리 >= 50)
{
SB_SetText("오류로 인한 중지 - 인벤토리 1칸이상 비우고 시작해"   ,1)
return
}
if (Result_Msg_Addr = 0 || Result_Msg_Addr ="")
{
	setTimer,스킬사용, off
	메모리실행("무기탈거")
	sleep, 100
	책좌표X := mem.read(0x0058EB48, "UInt", 0xBC)
	책좌표Y := mem.read(0x0058EB48, "UInt", 0xC0)
	수련좌표X := 책좌표X + 80
	수련좌표Y := 책좌표Y - 16
	마우스이동(수련좌표X,수련좌표Y)
	sleep, 10
	마우스클릭(수련좌표X,수련좌표Y)
	sleep, 10
	startAddress := 0x0F000000
	endAddress := 0x4FFFFFFF
	SetFormat, Integer, H
	Result_Msg_Addr := mem.processPatternScan(startAddress, endAddress, 0xE4, 0xC2, 0x28, 0xD3, 0x88, 0xD5, 0xB5, 0xC2, 0xC8, 0xB2, 0xE4, 0xB2, 0x44, 0xD5, 0x94, 0xC6) ;"실패했습니다필요" 검색
	GuiControl,, Result_Msg_Addr, %Result_Msg_Addr%
	SetFormat, Integer, D
	if !(Result_Msg_Addr>0)
	{
	startAddress := 0x0F000000
	endAddress := 0x4FFFFFFF
	SetFormat, Integer, H
	Result_Msg_Addr := mem.processPatternScan(startAddress, endAddress, 0xE4, 0xC2, 0x28, 0xD3, 0x88, 0xD5, 0xB5, 0xC2, 0xC8, 0xB2, 0xE4, 0xB2, 0x20, 0x00, 0x44, 0xD5) ;"실패했습니다 필" 검색
	GuiControl,, Result_Msg_Addr, %Result_Msg_Addr%
	SetFormat, Integer, D
	}
	sleep, 10
	setTimer,스킬사용, 1000
}
if (Result_Msg_Addr>0)
{
goodtogo := 1
처음시작 := 1
Coin := 1
성공실패주소 := 1
SB_SetText("성공",1)
}
else
{
SB_SetText("실패, 종료"   ,1)
COIN := 0
return
}
}
if (처음시작 = 1 || 처음시작 = 0)
{
처음시작 := 2
gosub, 어빌리티읽어오기
Gui,ListView,어빌리티리스트
Loop % LV_GetCount()
{
LV_GetText(abillity_name, A_Index, 3)
LV_GetText(abillity, A_Index, 5)
if (abillity_name = "미용")
{
미용어빌 := abillity
미용제한 := (Floor(미용어빌 / 10) + 1) * 10
SB_SetText("미용제한 " 미용제한, 2)
}
else if (abillity_name = "요리")
{
요리어빌 := abillity
요리제한 := (Floor(요리어빌 / 10) + 1) * 10
SB_SetText("요리제한 " 요리제한, 2)
}
else if (abillity_name = "재단")
{
재단어빌 := abillity
재단제한 := (Floor(재단어빌 / 10) + 1) * 10
SB_SetText("재단제한 " 재단제한, 2)
}
else if (abillity_name = "세공")
{
세공어빌 := abillity
세공제한 := (Floor(세공어빌 / 10) + 1) * 10
SB_SetText("세공제한 " 세공제한, 2)
}
else if (abillity_name = "스미스")
{
스미스어빌 := abillity
스미스제한 := (Floor(스미스어빌 / 10) + 1) * 10
SB_SetText("스미스제한 " 스미스제한, 2)
}
else if (abillity_name = "목공")
{
목공어빌 := abillity
목공제한 := (Floor(목공어빌 / 10) + 1) * 10
SB_SetText("목공제한 " 목공제한, 2)
}
else if (abillity_name = "연금술")
{
연금술어빌 := abillity
연금술제한 := (Floor(연금술어빌 / 10) + 1) * 10
SB_SetText("연금술제한 " 연금술제한, 2)
}
}
}
cookdelay := 2800
sleep, % cookdelay
loop,
{
if (Coin = 0)
break
sleep, 100
Keyclick(0) ;수련키트 장착
sleep, 100
책좌표X := mem.read(0x0058EB48, "UInt", 0xBC)
책좌표Y := mem.read(0x0058EB48, "UInt", 0xC0)
수련좌표X := 책좌표X + 80
수련좌표Y := 책좌표Y - 16
마우스이동(수련좌표X,수련좌표Y)
sleep, 10
마우스클릭(수련좌표X,수련좌표Y)
sleep, 100
gosub, 넣을아이템입력
메모리실행("은행넣기")
SB_SetText("은행넣기" RepairCount ,1)
loop,  ; 0.05초마다 결과 확인
{
if (Coin = 0)
break
Read_Result_MSG := mem.readString(Result_Msg_Addr, 50, "UTF-16", aOffsets*)
ifinstring, Read_Result_MSG, 실패했습니다주세요.
{
delay := delay + 100
메모리실행("은행빼기")
sleep, 2000
Write_Result_MSG := mem.writeString(Result_Msg_Addr, "", "UTF-16", aOffsets*)
마우스클릭(수련좌표X,수련좌표Y)
sleep, 100
메모리실행("은행넣기")
SB_SetText("은행넣기" ,1)
SB_SetText("delay를 " delay " 로 재설정"   ,1)
}
else
{
break
}
sleep, 50
}
if (Coin = 0)
break
gosub, 어빌리티읽어오기
Gui,ListView,어빌리티리스트
Loop % LV_GetCount()
{
LV_GetText(abillity_name, A_Index, 3)
LV_GetText(abillity, A_Index, 5)
if (abillity_name = "미용")
{
미용어빌 := abillity
if (미용어빌 >= 미용제한)
gosub,중지
}
else if (abillity_name = "요리")
{
요리어빌 := abillity
if (요리어빌 >= 요리제한)
gosub,중지
}
else if (abillity_name = "재단")
{
재단어빌 := abillity
if (재단어빌 >= 재단제한)
gosub,중지
}
else if (abillity_name = "세공")
{
세공어빌 := abillity
if (세공어빌 >= 세공제한)
gosub,중지
}
else if (abillity_name = "스미스")
{
스미스어빌 := abillity
if (스미스어빌 >= 스미스제한)
gosub,중지
}
else if (abillity_name = "목공")
{
목공어빌 := abillity
if (목공어빌 >= 목공제한)
gosub,중지
}
else if (abillity_name = "연금술")
{
연금술어빌 := abillity
if (연금술어빌 >= 연금술제한)
gosub,중지
}
}
Count_A := 0
Current_time := A_TickCount
sleep, 1000
Keyclick(9) ;키아키트 장착
SB_SetText("키아키트 장착" ,1)
loop,  ; 0.5초마다 결과 확인
{
if (Coin = 0)
break
상승어빌이름주소 := 상승어빌주소 + 0x64
상승어빌값주소 := 상승어빌주소 + 0x264
상승어빌카운트주소 := 상승어빌주소 + 0x264 + 0x8
필요어빌카운트주소 := 상승어빌주소 + 0x264 + 0xA
상승어빌 := mem.readString(상승어빌이름주소, 20, "UTF-16", aOffsets*)
상승어빌번호 := mem.read(상승어빌이름주소, "UInt", aOffsets*)
상승어빌값 := mem.read(상승어빌값주소, "UInt", aOffsets*)
guicontrol, ,상승어빌, %상승어빌%
IfInString, 상승어빌, 연금술
상승어빌 := "연금술"
IfInString, 상승어빌, 스미스
상승어빌 := "스미스"
if (상승어빌 = "연금술" || 상승어빌 = "미용" || 상승어빌 = "요리" || 상승어빌 = "재단" || 상승어빌 = "스미스" || 상승어빌 = "세공" || 상승어빌 = "목공" )
{
상승어빌카운트 := mem.read(상승어빌카운트주소, "UShort", aOffsets*)
필요어빌카운트 := mem.read(필요어빌카운트주소, "UShort", aOffsets*)
if (기존어빌카운트 != 상승어빌카운트)
{
올른카운트 := 상승어빌카운트 - 기존어빌카운트 + 필요어빌카운트 * (상승어빌값 - 기존어빌)
기존어빌카운트 := 상승어빌카운트
기존어빌 := 상승어빌값
sb_settext(상승어빌 "(" Round(상승어빌값 / 100,2) " - " 상승어빌카운트 "/" 필요어빌카운트 ") " 올른카운트 "카운트 상승"  ,2)

break
}
}
if (A_TickCount - Current_time > 1000 )
{
Current_time := A_TickCount
Count_A += 1
SB_SetText("대기중" Count_A  ,1)
}
sleep, 1
if (Count_A > 11)
break
}

if (Coin = 0)
break
메모리실행("은행빼기")
SB_SetText("은행빼기" ,1)
if (RepairCount = 1)
{
gosub, 수리하기
RepairCount := 300
SB_SetText("수리완료"  ,1)
sleep, 500
}
RepairCount -= 1
sleep, %cookdelay%

}
return
}

행운장매수:

return

길탐수련:
{
	Gui, Submit, nohide
	Freeze_Move()
	Buy_Unlimitted()
	시작인벤토리 := mem.read(0x0058DAD4, "UInt", 0x178, 0xBE, 0x14) - floor((식빵갯수+49)/50)
	GuiControlGet, 수련용길탐색딜레이
	if 수련용길탐색딜레이 = 0
	{
		수련용길탐색딜레이 := 1000
	}
	Coin := 1
	loop,
	{
		if Coin != 1
			break

		;FP최소값 구하기
		; < 25 = 20
		; < 50 = 40
		; < 75 = 60
		; < 100 = 80
		gosub, 어빌리티읽어오기
		Gui,ListView,어빌리티리스트
		Loop % LV_GetCount()
		{
			LV_GetText(abillity_name, A_Index, 3)
			LV_GetText(abillity, A_Index, 5)
			if (abillity_name = "길탐색")
			{
				길탐어빌 := Floor(abillity)
				길탐제한 := 100
				break
			}
		}
		최소FP := Floor(길탐어빌/25)*20+20+5+20
		gosub, 아이템읽어오기
		현재인벤토리 := mem.read(0x0058DAD4, "UInt", 0x178, 0xBE, 0x14)
		GALRID := mem.read(0x0058DAD4, "UInt", 0x178, 0x6F)
		GuiControl,, GALRID, % GALRID
		if (식빵갯수 = 0) && (GALRID < 1000) ;갈리드가 1000이하면 빠꾸
		{
			SB_SetText("소지금액부족",2)
			break
		}
		else if (식빵갯수 = 0) || (시작인벤토리 >= 현재인벤토리) ;식빵이 0개면 식빵 구매하기
		{
			SB_SetText("식빵구매 NPC호출중",2)
			if (맵번호 = 204)
			{
				NPC이름 := "카딜라"
			}
			else if (맵번호 = 1200)
			{
				NPC이름 := ""
			}
			else if (맵번호 = 2200)
			{
				NPC이름 := ""
			}
			else if (맵번호 = 3200)
			{
				NPC이름 := ""
			}
			else if (맵번호 = 4200)
			{
				NPC이름 := "쿠키"
			}
			loop, 5
			{
				NpcMenuSelection := mem.read(0x0058F0A4, "UInt", aOffset*)
				if (NpcMenuSelection = 0)
					CallNPC(NPC이름)
				else
					break
				sleep, 100
			}
			loop, 5
			{
				NPCMENUSELECT("Buy")
				sleep, 100
				if (Check_Shop("Buy")!=0)
					break
			}
			NPC거래창첫번째메뉴클릭()
			쿠키28 := "식빵"
			카딜라38:="치즈"
			카딜라40:="식빵"

			loop, 40
			{
				if Coin!=1
					break
				target := NPC이름 . A_Index
				target := %target%
				if (target = "식빵") || (target = "치즈")
				{
					keyclick("K1")
					keyclick("K0")
					keyclick("K0")
				}
				keyclick("DownArrow")
				Now_Selected++
			}

			loop, 50
			{
				sleep,100
				NPC거래창OK클릭()
				inven := mem.read(0x0058DAD4, "UInt", 0x178, 0xBE, 0x14)
				if (inven > 45)
				{
					break
				}
			}
			sleep,1000
			NPC거래창닫기()
		}

		loop, 50
		{
			현재FP := mem.read(0x0058DAD4, "UInt", 0x178, 0x63)
			if (최소FP > 현재FP)
			{
				keyclick("k3")
				keyclick("k4")
			}
			else
				break
		}

		수련용길탐(0)
		sleep,100
		Loop, 1
		{
			상승어빌이름주소 := 상승어빌주소 + 0x64
			상승어빌값주소 := 상승어빌주소 + 0x264
			상승어빌카운트주소 := 상승어빌주소 + 0x264 + 0x8
			필요어빌카운트주소 := 상승어빌주소 + 0x264 + 0xA
			상승어빌 := mem.readString(상승어빌이름주소, 20, "UTF-16", aOffsets*)
			상승어빌번호 := mem.read(상승어빌이름주소, "UInt", aOffsets*)
			상승어빌값 := mem.read(상승어빌값주소, "UInt", aOffsets*)
			if (상승어빌 = "길탐색")
			{
				상승어빌카운트 := mem.read(상승어빌카운트주소, "UShort", aOffsets*)
				필요어빌카운트 := mem.read(필요어빌카운트주소, "UShort", aOffsets*)
				if (%상승어빌%기존어빌카운트 != 상승어빌카운트)
				{
					올른카운트 := 상승어빌카운트 - %상승어빌%기존어빌카운트 + 필요어빌카운트 * (상승어빌값 - %상승어빌%기존어빌)
					%상승어빌%기존어빌카운트 := 상승어빌카운트
					%상승어빌%기존어빌 := 상승어빌값
					sb_settext(상승어빌 "(" Round(상승어빌값 / 100,2) " - " 상승어빌카운트 "/" 필요어빌카운트 ") " 올른카운트 "카운트 상승"  ,2)
				}
				else (%상승어빌%기존어빌카운트 = 상승어빌카운트)
				{
					;SB_SetText("길탐딜레이재설정을 추천함" , 2)
				}
			}
		}
		loop, 50
		{
			현재FP := mem.read(0x0058DAD4, "UInt", 0x178, 0x63)
			if (최소FP > 현재FP)
			{
				keyclick("k3")
				keyclick("k4")
			}
			else
				break
		}
		sleep, %수련용길탐색딜레이%

	}
	;길탐색 클릭하기
	;길탐어빌 얼마올랐는지 확인하기
	;안올랐으면 Delay + 100 하기


	return
}

;-------------------------------------------------------
;-------MultiThread ------------------------------------
;-------------------------------------------------------

포레스트네자동대화핵심코드:
{
gui, submit, nohide
if (포레스트네자동대화 = 0)
{
	return
}

맵번호 := mem.read(0x0058EB1C, "UInt", 0x10E)
공격여부 := mem.read(0x0058DAD4, "UInt", 0x178, 0xEB)
gosub, 아이템읽어오기

if (맵번호 = 4003 && 빛나는가루갯수 >= 10)
{
	Freeze_Move()
	loop, 5
	{
		StartCount := A_TickCount
		keyclick("Tab")
		sleep, 350
		keyclick("Tab")
		sleep, 350
		callnpc("길잃은수색대")
		sleep,500
		if (Check_FormNumber()=0)
		{
			callnpc("길잃은수색대")
			sleep,500
		}
		else
			break
	}
	Check_FormNumber()
	NPCMsg := Check_NPCMsg()

	도움필요 := True
	포북대화 := True
	가루교환필요 := floor((빛나는가루갯수 - 10 ) / 100)
	나뭇가지교환필요 := floor(빛나는나뭇가지갯수 / 20)
	결정교환필요 := floor(빛나는결정갯수 / 100)
	교환필요 := 가루교환필요 + 나뭇가지교환필요 + 결정교환필요
	loop,
	{
		StartCount := A_TickCount
		교환필요 := 가루교환필요 + 나뭇가지교환필요 + 결정교환필요
		NPCMsg := Check_NPCMsg()
		temp := get_NPCTalk_cordi()
		sleep, 150
		x:=temp.x
		y:=temp.y

		ifinstring,NPCMsg,무슨 일로
		{
			;formnumber = 117
			keyclick("k6")
			mem.writeString(Result_Msg_Addr, "", "UTF-16", aOffsets*)
			if (도움필요)
			{
				x+=10
				y+=19
				마우스클릭(x,y) ;도움을주세요
			}
			else if (교환필요 > 0)
			{
				x-=24
				y+=31
				마우스클릭(x,y) ;교환
				sleep, 350
				if (가루교환필요 > 0)
				{
					SB_SetText("가루교환 " 가루교환필요 "회 남음" , 2)
					가루교환필요 -= 1
					x:=temp.x
					y:=temp.y -5
					마우스클릭(x,y)
				}
				else if (나뭇가지교환필요 > 0)
				{
					SB_SetText("나뭇가지교환 " 나뭇가지교환필요 "회 남음" , 2)
					나뭇가지교환필요 -= 1
					x:=temp.x
					y:=temp.y + 8
					마우스클릭(x,y)
				}
				else if (결정교환필요 > 0)
				{
					SB_SetText("결정교환 " 결정교환필요 "회 남음" , 2)
					결정교환필요 -= 1
					x:=temp.x
					y:=temp.y + 21
					마우스클릭(x,y)
				}
			}
			else
			{
				x-=48
				y+=42
				마우스클릭(x,y) ;종료
			}
		}
		else ifinstring,NPCMsg,빛나는결정을 얻다
		{
			;formnumber = 77
			mem.writeString(Result_Msg_Addr, "", "UTF-16", aOffsets*)
			keyclick("k6")
		}
		else ifinstring,NPCMsg,이런 곳까지 오
		{
			;formnumber = 77
			mem.writeString(Result_Msg_Addr, "", "UTF-16", aOffsets*)
			keyclick("k6")
		}

		else ifinstring,NPCMsg,어떤 도움
		{
			;formnumber = 93
			x-=20
			y+=20
			mem.writeString(Result_Msg_Addr, "", "UTF-16", aOffsets*)
			마우스클릭(x,y)
		}
		else ifinstring,NPCMsg,이 마법은 사실
		{
			;formnumber = 77
			mem.writeString(Result_Msg_Addr, "", "UTF-16", aOffsets*)
			keyclick("k6")
		}
		else ifinstring,NPCMsg,개인적으로
		{
			;formnumber = 77
			mem.writeString(Result_Msg_Addr, "", "UTF-16", aOffsets*)
			keyclick("k6")
		}
		else ifinstring,NPCMsg,이 마법에
		{
			;formnumber = 77
			mem.writeString(Result_Msg_Addr, "", "UTF-16", aOffsets*)
			keyclick("k6")
		}
		else ifinstring,NPCMsg,트렌트와
		{
			;formnumber = 77
			mem.writeString(Result_Msg_Addr, "", "UTF-16", aOffsets*)
			keyclick("k6")
		}
		else ifinstring,NPCMsg,효과를 얻다
		{
			mem.writeString(Result_Msg_Addr, "", "UTF-16", aOffsets*)
			;formnumber = 77
			keyclick("k6")
			도움필요 := False
		}
		else ifinstring,NPCMsg,부족합니다
		{
			mem.writeString(Result_Msg_Addr, "", "UTF-16", aOffsets*)
			;formnumber = 77
			keyclick("k6")
			도움필요 := False
		}
		else ifinstring,NPCMsg,빛나는가루 10개를
		{
			;formnumber = 81
			x-=16
			y+=13
			mem.writeString(Result_Msg_Addr, "", "UTF-16", aOffsets*)
			마우스클릭(x,y)
			도움필요 := False
		}
		else ifinstring,NPCMsg,빛나는가루가 부족합
		{
			;formnumber = 77
			mem.writeString(Result_Msg_Addr, "", "UTF-16", aOffsets*)
			keyclick("k6")
			도움필요 := False
		}
		else ifinstring,NPCMsg,조심하세요
		{
			mem.writeString(Result_Msg_Addr, "", "UTF-16", aOffsets*)
			keyclick("k6")
			포북대화 := False
		}
		else if (Check_FormNumber()=0)
		{
			mem.writeString(Result_Msg_Addr, "", "UTF-16", aOffsets*)
			keyclick("k6")
			포북대화 := False
		}
		if (포북대화 = False)
		{
			keyclick("k6")
			keyclick("k6")
			keyclick("k6")
			keyclick("k6")
			break
		}
		else
			sleep, 100
	}
}
else if (맵번호 = 4005)
{
	loop, 5
	{
		if (Check_FormNumber()=0)
		{
			callnpc("동쪽파수꾼")
			sleep,500
		}
		else
			break
	}
	loop, 5
	{
		if (Check_FormNumber()!=0)
		{
		KeyClick("K6")
		sleep, 100
		}
		else
			break
	}
	loop, 5
	{
		if (Check_FormNumber()=0)
		{
			callnpc("서쪽파수꾼")
			sleep,500
		}
		else
			break
	}
	loop, 5
	{
		if (Check_FormNumber()!=0)
		{
			KeyClick("K6")
			sleep, 100
		}
		else
			break
	}
}
Un_Freeze_Move()
Return
}

무기자동바꾸기:
{
무기자동바꾸기상태RunCount++
guicontrol, ,무기자동바꾸기상태, %무기자동바꾸기상태RunCount%
;격투 0
;시미터 4100
;롱소드 4097
Gui, Submit, nohide
if (일무기 = 1)
{
	무기_Coin := 0
	WaaponLimit := 0
}
else if (일벗무바 = 1)
{
	WaaponLimit := 1
	UsePunch := 1
	무기_Coin := 1
}
else if (이무기 = 1)
{
	WaaponLimit := 2
	UsePunch := 0
	무기_Coin := 1
}
else if (이벗무바 = 1)
{
	WaaponLimit := 2
	UsePunch := 1
	무기_Coin := 1
}
else if (삼무기 = 1)
{
	WaaponLimit := 3
	UsePunch := 0
	무기_Coin := 1
}
else if (삼벗무바 = 1)
{
	WaaponLimit := 3
	UsePunch := 1
	무기_Coin := 1
}

CurrentWeapon := mem.read(0x0058DAD4, "UInt", 0x121)
CurrentHit := mem.read(0x0058dad4,"UINT",0x1a5)
if (CurrentWeapon != 0)
{
	if (일번무기 = CurrentWeapon)
	{
		일번무기수리필요 := 0
	}
	else if (이번무기 = CurrentWeapon && WaaponLimit>=2)
	{
		이번무기수리필요 := 0
	}
	else if (삼번무기 = CurrentWeapon && WaaponLimit>=3)
	{
		삼번무기수리필요 := 0
	}
	else
	{
		if(다음기록위치 = 1)
			일번무기 := CurrentWeapon
		else if (다음기록위치 = 2)
			이번무기 := CurrentWeapon
		else if (다음기록위치 = 3)
			삼번무기 := CurrentWeapon
		다음기록위치++
		if 다음기록위치 > WaaponLimit
			다음기록위치 := 1
	}
}
if (WaaponLimit = 1)
{
	이번무기수리필요 := 0
	삼번무기수리필요 := 0
}
else if (WaaponLimit = 2)
{
	삼번무기수리필요 := 0
}
if (WaaponLimit >0)
{
	if(일번무기수리필요 > 30 || 이번무기수리필요 > 30 || 삼번무기수리필요 > 30)
	{
		NeedRepair := 1
		SB_setText("무기수리필요",1)
	}
}

if (무기_Coin = 0)
{
}
else if (LastHit != CurrentHit)
{
	일번무기수리필요++
	이번무기수리필요++
	삼번무기수리필요++
	LastHit := CurrentHit
	if (WeaponNumber > WaaponLimit)
	{
		WeaponNumber := 1
	}
	CurrentWeapon := mem.read(0x0058DAD4, "UInt", 0x121)
	;SB_SetText(CurrentWeapon, 2)
	if (CurrentWeapon = 0 || UsePunch = 0)
	{
		keyclick(WeaponNumber)
		sleep,350
		loop,
		{
			NewWeapon := mem.read(0x0058DAD4, "UInt", 0x121)
			if (NewWeapon = CurrentWeapon)
			{
				keyclick(WeaponNumber)
				sleep,350
			}
			else
			{
				break
			}
		}
		WeaponNumber++
	}
	else if (UsePunch = 1)
	{
		if (몸통찌르기사용 = 1)
		{
			if (몸통찌르기번호 = 0)
			{
			guicontrol, ,몸통찌르기사용, 0
			}
			else
			{
				mem.write(0x0058D603, 몸통찌르기번호, "Char", aOffsets*)
				sleep,50
				메모리실행("스킬사용")
			}
		}
		메모리실행("무기탈거")
	}
}

상승어빌이름주소 := 상승어빌주소 + 0x64
상승어빌값주소 := 상승어빌주소 + 0x264
상승어빌카운트주소 := 상승어빌주소 + 0x264 + 0x8
필요어빌카운트주소 := 상승어빌주소 + 0x264 + 0xA
상승어빌 := mem.readString(상승어빌이름주소, 20, "UTF-16", aOffsets*)
상승어빌번호 := mem.read(상승어빌이름주소, "UInt", aOffsets*)
상승어빌값 := mem.read(상승어빌값주소, "UInt", aOffsets*)
if (상승어빌 = "격투" || 상승어빌 = "도" || 상승어빌 = "검" || 상승어빌 = "단검" || 상승어빌 = "대검" || 상승어빌 = "대도" || 상승어빌 = "발굴" || 상승어빌 = "지하탐색" || 상승어빌 = "낚시")
{
	상승어빌카운트 := mem.read(상승어빌카운트주소, "UShort", aOffsets*)
	필요어빌카운트 := mem.read(필요어빌카운트주소, "UShort", aOffsets*)
	if (%상승어빌%기존어빌카운트 != 상승어빌카운트)
	{
		올른카운트 := 상승어빌카운트 - %상승어빌%기존어빌카운트 + 필요어빌카운트 * (상승어빌값 - %상승어빌%기존어빌)
		%상승어빌%기존어빌카운트 := 상승어빌카운트
		%상승어빌%기존어빌 := 상승어빌값
		sb_settext(상승어빌 "(" Round(상승어빌값 / 100,2) " - " 상승어빌카운트 "/" 필요어빌카운트 ") " 올른카운트 "카운트 상승"  ,2)
		삼초간올린어빌카운트 += 올른카운트
	}
}

Sam_delay := A_TickCount - Sam_Before
if (Sam_delay > 1000)
{
	Sam_InCount++
	Sam_Before := A_TickCount
	gui,listview,몬스터리스트
	몬스터리스트좀비몹확인 := LV_GetNext(0)
	좀비몹거리확인 := LV_GetText(타겟_Z, 몬스터리스트좀비몹확인, 12)
	IsMoving := mem.read(0x0058EB1C, "UInt", 0x174)
	if (삼초간올린어빌카운트 = 0 && 몬스터리스트좀비몹확인 != 0 && 좀비몹거리확인 = 1 && Sam_InCount > 5 && IsMoving = 0)
	{
		Sam_InCount := 0
		sb_settext("좀비몹의심",1)
		keyclick("Tab")
		sleep, 300
		keyclick("Tab")
		sleep, 300
		좀비몹 := True
		lv_gettext(현재타겟분류,몬스터리스트좀비몹확인,1)
		lv_gettext(현재타겟차원,몬스터리스트좀비몹확인,2)
		lv_gettext(현재타겟맵이름,몬스터리스트좀비몹확인,3)
		lv_gettext(현재타겟맵번호,몬스터리스트좀비몹확인,4)
		lv_gettext(현재타겟이름,몬스터리스트좀비몹확인,5)
		lv_gettext(현재타겟OID,몬스터리스트좀비몹확인,6)
		lv_gettext(현재타겟X,몬스터리스트좀비몹확인,7)
		lv_gettext(현재타겟Y,몬스터리스트좀비몹확인,8)
		lv_gettext(현재타겟Z,몬스터리스트좀비몹확인,9)
		삼초간올린어빌카운트 := 0
		KeyClick("AltR")
		gui,listview,몬스터리스트
		LV_Modify(0, "-Select")

		gui,listview,블랙리스트
		블랙중복 := False
		loop % LV_GetCount()
		{
			lv_gettext(기존블랙OID,A_Index,6)
			if (기존블랙OID = 현재타겟OID)
			{
					블랙중복 := True
					break
			}
		}
		if (블랙중복 = False)
		{
			LV_Add("",현재타겟분류,현재타겟차원,현재타겟맵이름,현재타겟맵번호,현재타겟이름,현재타겟OID,현재타겟X,현재타겟Y,현재타겟Z,500)
		}
	}
	else if(삼초간올린어빌카운트 != 0 && 몬스터리스트좀비몹확인 != 0 && 좀비몹거리확인 = 1)
	{
		Sam_InCount := 0
		삼초간올린어빌카운트 := 0
		sb_settext("어빌상승됨",1)
	}
	else if (IsMoving != 0)
	{
		Sam_InCount := 0
		삼초간올린어빌카운트 := 0
		sb_settext("어빌상승됨",1)
	}
}

return
}

스킬사용:
{
스킬사용상태RunCount++
guicontrol, ,스킬사용상태, %스킬사용상태RunCount%

skill :=
for Index, skill in CommonSkillList
{
	if (%skill%사용 = 1)
	{
		if (%skill%번호 = 0)
		{
		guicontrol, ,%skill%사용, 0
		}
		else
		{
			loop, 2
			{
				mem.write(0x0058D603, %skill%번호, "Char", aOffsets*)
				sleep,50
				메모리실행("스킬사용")
			}
		}
	}
}
SK_Delay := A_TickCount - NSK_Counts
if (SK_Delay > 5000 )
{
	NSK_Counts := A_TickCount
	for Index, skill in NormalSkillList
	{
		if (%skill%사용 = 1)
		{
			if (%skill%번호 = 0)
			{
				guicontrol, ,%skill%사용, 0
			}
			else
			{
				loop, 2
				{
					mem.write(0x0058D603, %skill%번호, "Char", aOffsets*)
					sleep,50
					메모리실행("스킬사용")
				}
			}
		}
	}
}

gui,listview,몬스터리스트
원거리대상갯수 := LV_Getcount()
근거리대상위치 := LV_GetNext(0)
if (원거리대상갯수 > 0)
{
	LV_GetText(종류, 원거리루프, 1)
	if (종류 = "몬스터")
	{
		lv_gettext(특수원거리타겟OID,원거리루프,6)
		lv_gettext(근거거리타겟OID,근거리대상위치,6)
		;mem.write(0x00584C2C, 현재타겟OID, "UInt", aOffsets*)
	}
	else
	{
		원거리루프++
		if (원거리루프 >= 원거리대상갯수)
		{
			원거리루프 := 1
		}
	}
}

spell :=
for Index, spell in SpellList
{
	gui,listview,몬스터리스트
	몬스터리스트선택 := LV_GetNext(0)
	if (%spell%사용 = 1) && (spell = "리메듐" || spell = "라리메듐" || spell = "엘리메듐" || spell = "클리드" || spell = "브렐" || spell = "브레마" || spell = "쿠로" )
		마법사용(spell, "자신")
	else if (%spell%사용 = 1 && 몬스터리스트선택 != 0)
	{
		if (%spell%번호 = 0)
		{
			guicontrol, ,%spell%사용, 0
		}
		else if (특수원거리타겟OID != 0x0)
		{
			sleep,10
			마법사용(spell, 특수원거리타겟OID)
		}
	}
}

skill :=
for Index, skill in TargetSkillList
{
gui,listview,몬스터리스트
몬스터리스트선택 := LV_GetNext(0)
if (%skill%사용 = 1 && 몬스터리스트선택 != 0)
{
if (%skill%번호 = 0)
{
guicontrol, ,%skill%사용, 0
}
else
{
대상 := "클릭된대상"
타겟스킬번호 := 0
타겟스킬대상 := 0
SetFormat, Integer, H
if (대상 = "자신")
{
타겟스킬대상 := mem.read(0x0058DAD4, "UInt", 0x62)
}
else if (대상 = "클릭된대상")
{
타겟스킬대상 := mem.read(0x00584C2C, "UInt", aOffsets*)
}
if !(Skill = "무기공격")
{
타겟스킬대상 := 근거거리타겟OID
}
if (%skill%번호 != 0 && 타겟스킬대상 != 0)
{
메모리권한변경및쓰기("타겟스킬호출")
mem.write(0x0058FF3A, %skill%번호, "char", aOffsets*)
mem.write(0x0058FF3B, 타겟스킬대상, "UInt", aOffsets*)
sleep,50
메모리실행("타겟스킬사용")
}
SetFormat, Integer, D
}
}
}

if (리메듐사용여부 = 1 && 리메듐사용제한 > 현재HP)
{
마법사용("리메듐", "자신")
;SB_SETTEXT("현재체력" 현재HP "/ 리메듐사용제한 체력" 리메듐사용제한 "으로 인해 리메듐 사용",1)
}

if (브렐사용여부 = 1 && 브렐사용제한 > 현재MP)
{
마법사용("브렐","자신")
}

if (3번 = 1)
{
keyclick(3)
;    sleep, 10
}
if (4번 = 1)
{
keyclick(4)
;   sleep, 10
}
if (5번 = 1)
{
keyclick(5)
;    sleep, 10
}
if (6번 = 1)
{
keyclick(6)
;   sleep, 10
}
if (7번 = 1)
{
keyclick(7)
;   sleep, 10
}
if (8번 = 1)
{
keyclick(8)
;   sleep, 10
}
return
}

메모리_주변검색:
{
메모리_주변검색상태RunCount++
guicontrol, ,메모리_주변검색상태, %메모리_주변검색상태RunCount%

if (TargetTitle = "")
{
	SB_SETtext("ERROR-U-0" TargetTitle ,2)
}

Gui, Submit, Nohide
맵번호 := mem.read(0x0058EB1C, "UInt", 0x10E)
if (CHECKED맵번호 != 맵번호)
{
	;SB_SETtext("CHECKED맵번호" CHECKED맵번호 "현재맵번호" 맵번호 ,2)
	CHECKED맵번호 := 맵번호
	Gui, listview, 좌표리스트
	LV_Delete()
	Gui, listview, 몬스터리스트
	LV_Delete()
	Gui, listview, 아이템리스트
	LV_Delete()
	LoadCoordData()
}

맵이름 := mem.readString(mem.getModuleBaseAddress("jelancia_core.dll")+0x44A28, 50, "UTF-16", 0xC)
GuiControl,, 맵,%맵이름%(%맵번호%)

좌표X := mem.read(0x0058DAD4, "UInt", 0x10)
좌표Y := mem.read(0x0058DAD4, "UInt", 0x14)
좌표Z := mem.read(0x0058DAD4, "UInt", 0x18)
GuiControl,, 좌표, X: %좌표X% Y: %좌표Y% Z: %좌표Z%

현재HP := mem.read(0x0058DAD4, "UInt", 0x178, 0x5B)
최대HP := mem.read(0x0058DAD4, "UInt", 0x178, 0x1F)
GuiControl,, HP, % 현재HP . " / " . 최대HP

현재MP := mem.read(0x0058DAD4, "UInt", 0x178, 0x5F)
최대MP := mem.read(0x0058DAD4, "UInt", 0x178, 0x23)
GuiControl,, MP, % 현재MP . " / " . 최대MP

현재FP := mem.read(0x0058DAD4, "UInt", 0x178, 0x63)
최대FP := mem.read(0x0058DAD4, "UInt", 0x178, 0x27)
GuiControl,, FP, % 현재FP . " / " . 최대FP

gui,submit, nohide
startAddress := 0x005907D4
endAddress := 0x00590800
Loop
{
	; 현재 주소에서 4바이트 데이터 읽기
	data := mem.read(startAddress, "UInt", aOffsets*)

	; 데이터를 배열에 추가
	if (!IsDataInList(data, MonsterList))
		MonsterList.Push(data)

	; 다음 주소로 이동
	startAddress += 4

	; 범위 끝에 도달하면 종료
	if (startAddress > endAddress)
		break
}

;0xAC, 0x20, 0x54, 0x00
맵번호 := mem.read(0x0058EB1C, "UInt", 0x10E)
맵이름 := mem.readString(mem.getModuleBaseAddress("jelancia_core.dll")+0x44A28, 50, "UTF-16", 0xC)
차원 := Get_Dimension()

gui,listview,신규몬스터리스트
LV_DELETE()
for index, result in MonsterList
{
	result := Format("0x{:08X}", result)
	addr := mem.read(result, "UInt", aOffsets*)
	if (addr != 0x005420AC)
	{
		MonsterList.RemoveAt(index)
	}
	else
	{
		find_x := mem.read(result + 0x0C, "UInt", aOffsets*)
		find_y := mem.read(result + 0x10, "UInt", aOffsets*)
		find_z := mem.read(result + 0x14, "UInt", aOffsets*)
		findMID := mem.read(result + 0x82, "UInt", aOffsets*)
		SetFormat, Integer, H
		find_object_id := mem.read(result + 0x5E, "UInt",aOffsets*)
		find_object_id := Format("0x{:08X}", find_object_id)
		SetFormat, Integer, D
		find_name := mem.readString(mem.read(result + 0x62, "UInt", aOffsets*), 50, "UTF-16",aOffsets*)

		kind := "몬스터"
		for index, name in 게임내쓸때없는존재들
		{
			if (InStr(find_name, name))
			{
				kind := "간판"
				break
			}
		}
		for index, 번호 in 이름이바뀌는존재들
		{
			if (findMID = 번호)
			{
				kind := "쓰래기"
				break
			}
		}
		for index, name in 게임내고용상인들
		{
			if (InStr(find_name, name))
			{
				kind := "고용상인"
				break
			}
		}
		if (kind = "몬스터")
		{
			for index, name in 게임내NPC들
			{
				if (InStr(find_name, name))
				{
					kind := "NPC"
					break
				}
			}
		}

		DB_RECORD(kind,맵번호,맵이름,find_name,findMID,find_x,find_y,find_z)
		gui,listview,신규몬스터리스트
		if ( kind = "몬스터" ) || (맵번호 = 237 || 맵번호 = 1403 || 맵번호 = 2300 ||맵번호 = 3300 || 맵번호 =  3301) || ( kind = "NPC" || 맵번호 = 201)
			LV_Add("", kind, 차원, 맵이름, 맵번호, find_name, find_object_id, find_x, find_y, find_z, result)
		gui,listview,몬스터리스트
		deletedelay1 := deletedelay  + 1
		IsNewOID := True
		loop % LV_GetCount()
		{
			LV_GetText(기존_object_id, A_Index, 6)
			if(기존_object_id = find_object_id)
			{
				;분류|차원|맵이름|번호|이름|OID|X|Y|Z|주소|삭제카운트|거리|이미지
				LV_Modify(A_Index, "", kind, 차원, 맵이름, 맵번호, find_name, find_object_id, find_x, find_y, find_z, result, deletedelay1, ,findMID)
				IsNewOID := False
				if (보조윈도우 = 1)  ; YouTube촬영용, 공유시 지워야함
				{
					x := (find_x - 좌표X + 16) * pixelsize
					y := (find_y - 좌표Y + 8) * pixelsize
					GuiControl, 보조윈도우: Move, %find_object_id%, x%x% y%y%
				}
			}
		}
		if ( IsNewOID && find_x != "" && find_y != "")
		{
			if (kind = "몬스터") || (맵번호 = 237 || 맵번호 = 1403 || 맵번호 = 2300 ||맵번호 = 3300 || 맵번호 =  3301)||( kind = "NPC" || 맵번호 = 201)
				LV_Add("", kind, 차원, 맵이름, 맵번호, find_name, find_object_id, find_x, find_y, find_z, result, deletedelay1, ,findMID)
			if ( kind = "NPC" )
			{
				NPC리스트추가(kind, 차원, 맵이름, 맵번호, find_name, find_object_id, find_x, find_y, find_z, 중요도, result, findMID)
				if (보조윈도우 = 1) ; YouTube촬영용, 공유시 지워야함
				{
					;===보조윈도우===
					x := (find_x - 좌표X + 16) * pixelsize
					y := (find_y - 좌표Y + 8) * pixelsize

					if IsDataInList(find_object_id, IsGuiExist)
					{
						GuiControl, 보조윈도우: Move, %find_object_id%, x%x% y%y%
					}
					else
					{
						IsGuiExist.push(find_object_id)
						Gui, 보조윈도우: Add, Picture, x%x% y%y% w%pixelsize% h%pixelsize%  v%find_object_id%, %pinkimage%
					}
				}
			}
			else if (kind = "고용상인") && ( 맵번호 = 237 || 맵번호 = 1403 || 맵번호 = 2300 ||맵번호 = 3300 || 맵번호 =  3301)
			{
				NPC리스트추가(kind, 차원, 맵이름, 맵번호, find_name, find_object_id, find_x, find_y, find_z, 중요도, result, findMID)
				if (보조윈도우 = 1) ; YouTube촬영용, 공유시 지워야함
				{
					;===보조윈도우===
					x := (find_x - 좌표X + 16) * pixelsize
					y := (find_y - 좌표Y + 8) * pixelsize

					if IsDataInList(find_object_id, IsGuiExist)
					{
						GuiControl, 보조윈도우: Move, %find_object_id%, x%x% y%y%
					}
					else
					{
						IsGuiExist.push(find_object_id)
						Gui, 보조윈도우: Add, Picture, x%x% y%y% w%pixelsize% h%pixelsize%  v%find_object_id%, %pinkimage%
					}
				}
			}
			else
			{
				if (보조윈도우 = 1) ; YouTube촬영용, 공유시 지워야함
				{
					x := (find_x - 좌표X + 16) * pixelsize
					y := (find_y - 좌표Y + 8) * pixelsize
					if (x="" || y="")
					{
						x := -20
						y := -20
					}
					if IsDataInList(find_object_id, IsGuiExist)
					{
						GuiControl, 보조윈도우: Move, %find_object_id%, x%x% y%y%
					}
					else
					{
						IsGuiExist.push(find_object_id)
						Gui, 보조윈도우: Add, Picture, x%x% y%y% w%pixelsize% h%pixelsize%  v%find_object_id%, %redimage%
					}
				}
			}
		}
	}
}


gui,listview,몬스터리스트
temp_i := 1
loop % LV_GetCount()
{
	LV_GetText(분류, temp_i, 1)
	LV_GetText(기존_카운트, temp_i, 11)
	업데이트_카운트 := 기존_카운트 - 1
	if (업데이트_카운트 < 0)
	{
		x := -1 * pixelsize
		y := -1 * pixelsize
		LV_gettext(find_object_id, temp_i, 6)
		if (보조윈도우 = 1)
		{
			GuiControl, 보조윈도우: Move, %find_object_id%, x%x% y%y%
		}
	}
	if (업데이트_카운트 < 0 && 분류 != "NPC" && 분류 != "고용상인")
	{
		LV_delete(temp_i)
		temp_i -= 1
	}
	else
	{
		LV_Modify(temp_i,"Col11", 업데이트_카운트)
	}
	temp_i++
}

startAddress := 0x00590B44
endAddress := 0x00590B80
Loop {
	; 현재 주소에서 4바이트 데이터 읽기
	data := mem.read(startAddress, "UInt", aOffsets*)

	; 데이터를 배열에 추가
	if (!IsDataInList(data, PlayerList))
		PlayerList.Push(data)

	; 다음 주소로 이동
	startAddress += 4

	; 범위 끝에 도달하면 종료
	if (startAddress > endAddress)
		break
}


gui,listview,신규플레이어리스트
LV_delete()
for index, result in PlayerList
{
	result := Format("0x{:08X}", result)
	addr := mem.read(result, "UInt", aOffsets*)
	if (addr != 0x0053E38C)
	{
		PlayerList.RemoveAt(index)
	}
	else
	{
		find_x := mem.read(result + 0x0C, "UInt", aOffsets*)
		find_y := mem.read(result + 0x10, "UInt", aOffsets*)
		find_z := mem.read(result + 0x14, "UInt", aOffsets*)
		SetFormat, Integer, H
		find_object_id := mem.read(result + 0x5E, "UInt",aOffsets*)
		find_object_id := Format("0x{:08X}", find_object_id)
		SetFormat, Integer, D
		find_name := mem.readString(mem.read(result + 0x62, "UInt", aOffsets*), 50, "UTF-16",aOffsets*)
		차원 := Get_Dimension()
		gui,listview,신규플레이어리스트
		LV_Add("", "플레이어", 차원, 맵이름, 맵번호, find_name, find_object_id, find_x, find_y, find_z, result)
		IsNewOID := True
		gui,listview,플레이어리스트
		deletedelay1 := deletedelay + 1
		loop % LV_GetCount()
		{
			LV_GetText(기존_object_id, A_Index, 6)
			if(기존_object_id = find_object_id)
			{
				LV_Modify(A_Index, "", "플레이어", 차원, 맵이름, 맵번호, find_name, find_object_id, find_x, find_y, find_z, result, deletedelay1)
				IsNewOID := False
				if (보조윈도우 = 1) ; YouTube촬영용, 공유시 지워야함
				{
					x := (find_x - 좌표X + 16) * pixelsize
					y := (find_y - 좌표Y + 8) * pixelsize
					GuiControl, 보조윈도우: Move, %find_object_id%, x%x% y%y%
				}
			}
		}
		if IsNewOID
		{
			gui,listview,플레이어리스트
			LV_Add("", "플레이어", 차원, 맵이름, 맵번호, find_name, find_object_id, find_x, find_y, find_z, result,deletedelay1)
			if (보조윈도우 = 1)  ; YouTube촬영용, 공유시 지워야함
			{
				x := (find_x - 좌표X + 16) * pixelsize
				y := (find_y - 좌표Y + 8) * pixelsize
				if IsDataInList(find_object_id, IsGuiExist)
				{
					GuiControl, 보조윈도우: Move, %find_object_id%, x%x% y%y%
				}
				else
				{
					IsGuiExist.push(find_object_id)
					Gui, 보조윈도우: Add, Picture, x%x% y%y% w%pixelsize% h%pixelsize%  v%find_object_id%, %blackimage%
				}
			}
		}
	}
}

temp_i := 1
gui,listview,플레이어리스트
loop % LV_GetCount()
{
	LV_GetText(기존_카운트, temp_i, 11)
	업데이트_카운트 := 기존_카운트 - 1
	if (업데이트_카운트 < 0)
	{
		x := -1 * pixelsize
		y := -1 * pixelsize
		LV_gettext(find_object_id, temp_i, 6)
		if (보조윈도우 = 1)
		{
			GuiControl, 보조윈도우: Move, %find_object_id%, x%x% y%y%
		}
	}
	if (업데이트_카운트 < 0)
	{
		LV_delete(temp_i)
		temp_i -= 1
	}
	else
	{
		LV_Modify(temp_i,"Col11", 업데이트_카운트)
	}
	temp_i++
}

startAddress := 0x005908A4
endAddress := 0x00590900
Loop
{
; 현재 주소에서 4바이트 데이터 읽기
data := mem.read(startAddress, "UInt", aOffsets*)

; 데이터를 배열에 추가
if (!IsDataInList(data, itemList))
	itemList.Push(data)

; 다음 주소로 이동
startAddress += 4

; 범위 끝에 도달하면 종료
if (startAddress > endAddress)
	break
}


gui,listview,신규아이템리스트
LV_DELETE()
for index, result in itemList
{
	result := Format("0x{:08X}", result)
	addr := mem.read(result, "UInt", aOffsets*)
	if (addr != 0x0053ECA4)
	{
		itemList.RemoveAt(index)
	}
	else
	{
		find_x := mem.read(result + 0x0C, "UInt",aOffsets*)
		find_y := mem.read(result + 0x10, "UInt",aOffsets*)
		find_z := mem.read(result + 0x14, "UInt",aOffsets*)
		SetFormat, Integer, H
		find_object_id := mem.read(result + 0x5E, "UInt",aOffsets*)
		find_object_id := Format("0x{:08X}", find_object_id)
		SetFormat, Integer, D
		find_name := mem.readString(mem.read(result + 0x62, "UInt",aOffsets*), 50, "UTF-16",aOffsets*)
		gui,listview,신규아이템리스트
		LV_Add("", "아이템", 차원, 맵이름, 맵번호, find_name, find_object_id, find_x, find_y, find_z, result)
		MapNumber := mem.read(0x0058EB1C, "UInt", 0x10E)
		NoOneOnTheItem := True
		;광물캐기코드, 공유시 지워야함
		if ( MapNumber = 237 || MapNumber = 1403 || MapNumber = 2300 ||MapNumber = 3300 || MapNumber =  3301 || MapNumber =  11 )
		{
			if (find_z = 0)
			{
				gui, listview, 플레이어리스트
				loop % LV_GetCount()
				{
					LV_GetText(기존_x, A_Index, 7)
					LV_GetText(기존_y, A_Index, 8)
					if(find_x = 기존_x && find_y = 기존_y)
					NoOneOnTheItem := False
				}
				gui, listview, 몬스터리스트
				loop % LV_GetCount()
				{
					LV_GetText(기존_x, A_Index, 7)
					LV_GetText(기존_y, A_Index, 8)
					if(find_x = 기존_x && find_y = 기존_y)
					NoOneOnTheItem := False
				}
			}
		}
		좌표X := mem.read(0x0058DAD4, "UInt", 0x10)
		좌표Y := mem.read(0x0058DAD4, "UInt", 0x14)
		좌표Z := mem.read(0x0058DAD4, "UInt", 0x18)
		temp_i := 1
		gui,listview,아이템리스트
		loop % LV_GetCount()
		{
			LV_GetText(기존_카운트, temp_i, 11)
			LV_GetText(타겟_X, temp_i, 7)
			LV_GetText(타겟_Y, temp_i, 8)
			distanceX := Abs(타겟_X - 좌표X)
			distanceY := Abs(타겟_Y - 좌표Y)
			if (기존_카운트 < 0 && distanceX < 16 && distanceY < 9)
			{
				LV_delete(temp_i)
				temp_i -= 1
			}
			else
			{
				업데이트_카운트 := 기존_카운트 - 1
				LV_Modify(temp_i,"Col11", 업데이트_카운트)
			}
			temp_i++
		}
		IsWantedItem := False
		gui,listview,원하는아이템리스트
		loop % LV_GetCount()
		{
			LV_GetText(원하는아이템, A_Index)
			if (원하는아이템 != "" && find_name != "")
			{
				ifinstring, find_name, %원하는아이템%
				IsWantedItem := True
			}
		}

		deletedelay1 := deletedelay + 1
		temp_i := 1
		gui,listview,아이템리스트
		IsNewOID := True
		loop % LV_GetCount()
		{
			LV_GetText(기존_object_id, temp_i, 6)
			if(기존_object_id = find_object_id)
			{
				if NoOneOnTheItem
					LV_Modify(temp_i, "", "아이템", 차원, 맵이름, 맵번호, find_name, find_object_id, find_x, find_y, find_z, result, deletedelay)
				if !NoOneOnTheItem
				{
					Lv_delete(temp_i)
					temp_i -= 1
				}
				IsNewOID := False
			}
			temp_i++
		}

		PassBlacklisted := True
		if (맵번호 = 3006 && find_x = 27 && find_y = 32 && find_z = 0)
			isBlakclisted := False
		if (IsNewOID && NoOneOnTheItem && IsWantedItem && PassBlacklisted)
		{
			gui,listview,아이템리스트
			LV_Add("", "아이템", 차원, 맵이름, 맵번호, find_name, find_object_id, find_x, find_y, find_z, result, deletedelay)
		}
	}
}

temp_i := 1
gui,listview,아이템리스트
loop % LV_GetCount()
{
	LV_GetText(기존_카운트, temp_i, 11)
	LV_GetText(타겟_X, temp_i, 7)
	LV_GetText(타겟_Y, temp_i, 8)
	distanceX := Abs(타겟_X - 좌표X)
	distanceY := Abs(타겟_Y - 좌표Y)
	if (기존_카운트 < 0 && distanceX < 16 && distanceY < 9)
	{
		LV_delete(temp_i)
		temp_i -= 1
	}
	else
	{
		업데이트_카운트 := 기존_카운트 - 1
		LV_Modify(temp_i,"Col11", 업데이트_카운트)
	}
	temp_i++
}

temp_i := 1
gui,listview,블랙리스트
loop % LV_GetCount()
{
	LV_GetText(기존_카운트, temp_i, 10)
	if (기존_카운트 < 0)
	{
		LV_delete(temp_i)
		temp_i -= 1
	}
	else
	{
		업데이트_카운트 := 기존_카운트 - 1
		LV_Modify(temp_i,"Col10", 업데이트_카운트)
	}
	temp_i++
}
return
}

기타동작:
{
gui, submit, nohide
기타동작상태RunCount++
guicontrol, ,기타동작상태, %기타동작상태RunCount%

gosub, NPC대화창으로방해하는지확인
gosub, 아이템읽어오기

if !(마을귀환성공여부)
{
	sleep, 100
	맵번호 := mem.read(0x0058EB1C, "UInt", 0x10E)
	if (맵번호 = 2 || 맵번호 = 1002 || 맵번호 = 2002 || 맵번호 = 3002 || 맵번호 = 4002)
	{
		마을귀환성공여부 := True
	}
	else ;if !(맵번호 = 2 || 맵번호 = 1002 || 맵번호 = 2002 || 맵번호 = 3002 || 맵번호 = 4002)
	{
		마을 := "포프레스네"
		목적차원 := "베타"
		라깃사용하기(마을,목적차원)
	}
}

인벤토리 := mem.read(0x0058DAD4, "UInt", 0x178, 0xBE, 0x14)
맵번호 := mem.read(0x0058EB1C, "UInt", 0x10E)

if (라스의깃열려있는지확인() != 0)
{
	SB_SETtext("ERROR-U-1",2)
	stopsign := True
	return
}

if (현재HP = "" || 최대HP = "" || 최대MP = "" || 최대FP = "" || 인벤토리 = "")
{
	SB_SETtext("ERROR-U-4",2)
	return
}

if !(인벤토리 > 0 && 인벤토리 <= 50)
{
	SB_SETtext("ERROR-U-3",2)
	return
}
else if (인벤토리 > 0 && 인벤토리 < 50) && !(맵번호 != 2 && 맵번호 != 1002 && 맵번호 != 2002 && 맵번호 != 3002 && 맵번호 != 4002 )
{
	인벤토리점검필요 := 0
}
else if (인벤토리 = 50)
{
	Item_delay := A_TickCount - Item_Delays
	if (Item_delay > 1000)
	{
		Item_Delays := A_TickCount
		if (인벤토리점검필요 > 10)
		{
			guicontrol, ,마지막사냥장소, %맵번호%
			guicontrol, ,마을귀환이유, 인벤수량50개
			keyclick(오란의깃사용단축키)
			마을귀환성공여부 := False
			return
		}
		인벤토리점검필요++
		SB_SetText("인벤토리 비워주세요.",2)
	}
}


if (힐링포션사용여부 = 1 && 힐링포션사용제한 > 현재HP && 맵번호 != 2 && 맵번호 != 1002 && 맵번호 != 2002 && 맵번호 != 3002 && 맵번호 != 4002 )
{
	keyclick(힐링포션사용단축키)
}

if (HP마을귀환사용여부 = 1 && HP마을귀환사용제한 > 현재HP && 현재HP != "" && 맵번호 != 2 && 맵번호 != 1002 && 맵번호 != 2002 && 맵번호 != 3002 && 맵번호 != 4002 )
{
	guicontrol, ,마지막사냥장소, %맵번호%
	마을귀환성공여부 := False
	guicontrol, ,마을귀환이유, 현재HP %현재HP% 가 %HP마을귀환사용제한% 보다 낮음
	keyclick(오란의깃사용단축키)
	마을쇼핑필요 := True
	SB_setText(HP마을귀환사용제한 "/" 현재HP "HP부족",1)
}

if (마나포션사용여부 = 1) && (마나포션사용제한 > 현재MP) && ( 현재MP != "") && (맵번호 != 2 && 맵번호 != 1002 && 맵번호 != 2002 && 맵번호 != 3002 && 맵번호 != 4002 )
{
	SB_SETtext("마나포션사용" ,2)
	keyclick(마나포션사용단축키)
}

if (MP마을귀환사용여부 = 1 && MP마을귀환사용제한 > 현재MP && 맵번호 != 2 && 맵번호 != 1002 && 맵번호 != 2002 && 맵번호 != 3002 && 맵번호 != 4002)
{
	guicontrol, ,마지막사냥장소, %맵번호%
	마을귀환성공여부 := False
	guicontrol, ,마을귀환이유, 현재MP %현재MP% 가 %MP마을귀환사용제한% 보다 낮음
	keyclick(오란의깃사용단축키)
	마을쇼핑필요 := True
	SB_setText(MP마을귀환사용제한 "/" 현재MP "HP부족",1)
}

if (식빵사용여부 = 1 && 식빵사용제한 > 현재FP && 최대FP !="" )
{
	SB_SETtext("식빵사용" 식빵사용카운트 ,2)
	keyclick(식빵사용단축키)
	if (현재FP기록 = 현재FP)
	{
		식빵사용카운트++
	}
	현재FP기록 := 현재FP
}
else if (식빵사용카운트 >= 5)
{
	if (맵번호 != 2 && 맵번호 != 1002 && 맵번호 != 2002 && 맵번호 != 3002 && 맵번호 != 4002 && 식빵갯수 = 0)
	{
		NeedRepair := 1
		guicontrol, ,마지막사냥장소, %맵번호%
		마을귀환성공여부 := False
		마을쇼핑필요 := True
		guicontrol, ,마을귀환이유, 식빵이부족해
		keyclick(오란의깃사용단축키)
		SB_setText("식빵부족" 식빵갯수,1)
		return
	}
}
else
{
식빵사용카운트 := 0
}

if (자동사냥여부 = 1)
{
	if (맵번호 = 2 || 맵번호 = 1002 || 맵번호 = 2002 || 맵번호 = 3002 || 맵번호 = 4002)
	{
		gosub, 아이템읽어오기
		GuiControlGet,마지막사냥장소
		if (라스의깃갯수 < 2 || 오란의깃갯수 < 2)
		{
			SB_setText("라깃구매",1)
			gosub, 라깃구매
		}
		else if (식빵갯수 < 180)
		{
			SB_setText("식빵구매",1)
			gosub, 식빵구매
		}
		else if (NeedRepair = 1)
		{
			SB_setText("무기수리",1)
			gosub, 무기수리
			NeedRepair := 0
		}
		else if (마지막사냥장소 = 4003 && 맵번호 = 4002 && isMoving = 0)
		{
			좌표입력(172,15,1)
			SB_SetText("자동이동10",4)
			메모리실행("좌표이동")
		}
	}
	else if (맵번호 = 4003) && (빛나는가루갯수 < 100 || 독성포자해독약갯수 < 10) && (인벤토리<40)
	{
		mem.writeString(0x005901E5, "", "UTF-16", aOffsets*)
		메모리권한변경및쓰기("아이템줍기실행")
	}
	else if (맵번호 = 4003)
	{
		메모리권한변경및쓰기("아이템줍기정지")
	}

}

if (맵번호 != 2 && 맵번호 != 1002 && 맵번호 != 2002 && 맵번호 != 3002 && 맵번호 != 4002 && NeedRepair = 1)
{
	마을귀환성공여부 := False
	guicontrol, ,마을귀환이유, 무기수리필요해
	keyclick(오란의깃사용단축키)
	SB_setText("무기수리필요",1)
	return
}



FormatTime, CurrentTime,, HH:mm  ; 현재 시간을 HH:mm 형식으로 가져옵니다.
SB_SetText(CurrentTime, 4)
If (CurrentTime = "23:58")  ; 포남링교환시간
{

}
else If (CurrentTime = "02:30" || CurrentTime = "06:30" || CurrentTime = "10:30" || CurrentTime = "14:30" || CurrentTime = "18:30" || CurrentTime = "22:30")  ; 유익인X출몰시간
{
	;라이트라이트 외치기
	;악용시 전 차원 무한 파라스 가능; 공유시 삭제 필요
}
else If (CurrentTime = "03:40" || CurrentTime = "07:40" || CurrentTime = "11:40" || CurrentTime = "15:40" || CurrentTime = "19:50" || CurrentTime = "23:40")  ; 조개교환시간
{
	;조개 외치기
	;악용시 전 차원 무한 파라스 가능; 공유시 삭제 필요
}

if (소각활성화 = 1)
{
	gui, listview, 소각할아이템대기리스트
	소각할아이템대기리스트갯수 := LV_GetCount()
	Loop % 소각할아이템대기리스트갯수
	{
		LV_GetText(아이템,A_index,1)
		if (아이템 != "" )
		{
			소각할아이템바꾸기 := mem.writeString(0x00590147, 아이템, "UTF-16", aOffsets*) ;소각할 아이템
			메모리실행("하나씩소각")
			LV_Delete(1)
		}
		sleep, 300
	}
}

if (은행넣기활성화 = 1)
{
	gui, listview, 은행넣을아이템대기리스트
	은행넣을아이템대기리스트갯수 := LV_GetCount()
	Loop % 은행넣을아이템대기리스트갯수
	{
		gui, listview, 은행넣을아이템대기리스트
		LV_GetText(아이템,A_index,1)
		if (아이템 != "" )
		{
			은행넣을아이템바꾸기 := mem.writeString(0x00590500, 아이템, "UTF-16", aOffsets*) ;은행에 넣을 아이템
			메모리실행("은행넣기")
			LV_Delete(1)
		}
		sleep, 300
	}
}

; 0 주먹
; 45057 활
if (무기사용여부 = 1)
{
	현재무기 := mem.read(0x0058DAD4, "UInt", 0x121)
	if (현재무기 = 0)
	{
		KeyClick(1)
	}
}

if (자동사냥여부 = 1)
{
	gui,listview,몬스터리스트
	몬스터리스트선택 := LV_GetNext(0)
	몬스터리스트갯수 := LV_GetCount()
	if ( 몬스터리스트갯수 > 0 )
	{
		gui,listview,몬스터리스트
		Loop % LV_GetCount()
		{
			gui,listview,몬스터리스트
			LV_GetText(타겟_X, A_Index, 7)
			LV_GetText(타겟_Y, A_Index, 8)
			LV_GetText(타겟_Z, A_Index, 9)
			distanceX := Abs(타겟_X - 좌표X)
			distanceY := Abs(타겟_Y - 좌표Y)
			distanceZ := Abs(타겟_Z - 좌표Z)
			;distanceXYZ := Abs( Abs(distanceX - distanceY) + distanceX) + distanceZ * 20
			distanceXYZ := distanceX + distanceY + distanceZ * 20
			LV_Modify(A_Index,"Col12", distanceXYZ)
		}
	}
	gui,listview,몬스터리스트
	몬스터리스트갯수 := LV_GetCount()
	몬스터리스트현재선택 := LV_GetNext(0)
	gui,listview,원하는몬스터리스트
	원하는몬스터리스트갯수 := LV_GetCount()
	if (몬스터리스트갯수 > 0 && 몬스터리스트현재선택 = 0)
	{
		거리 := 100
		선택 := 0
		Loop, %몬스터리스트갯수%
		{
			gui,listview,몬스터리스트
			LV_GetText(종류, A_Index, 1)
			LV_GetText(새거리, A_Index, 12)
			LV_GetText(몬스터이름, A_Index, 5)
			LV_GetText(몬스터OID, A_Index, 6)
			LV_GetText(타겟_X, A_Index, 7)
			LV_GetText(타겟_Y, A_Index, 8)
			distanceX := Abs(타겟_X - 좌표X)
			distanceY := Abs(타겟_Y - 좌표Y)
			몬스터찾음 := 0

			;몬스터 주변에 다른 플레이어가 있는지 확인
			P2MExist := 0
			gui,listview,플레이어리스트
			loop, LV_GetCount()
			{
				LV_GetText(플레이어X, A_Index, 7)
				LV_GetText(플레이어Y, A_Index, 8)
				P2MdistanceX := Abs(타겟_X - 플레이어X)
				P2MdistanceY := Abs(타겟_Y - 플레이어Y)
				if (P2MdistanceX = 1 && P2MdistanceY =1)
					P2MExist++
				if P2MExist > 1
					break
			}
			if P2MExist > 1
				break
			if (종류 = "" || 새거리 = "" || 몬스터이름 = "" || 몬스터OID = "" || 타겟_X = "" || 타겟_Y = "")
				Break
			if (distanceX < 16 && distanceY < 7 && distanceX + distanceY != 0 && 새거리 < 거리 && 종류 = "몬스터" )
			{
				if (원하는몬스터리스트갯수 > 0)
				{
					몬스터찾음 := 0
					loop, %원하는몬스터리스트갯수%
					{
						gui,listview,원하는몬스터리스트
						LV_GetText(사냥할몬스터이름, A_Index, 1)
						ifinstring, 몬스터이름, % 사냥할몬스터이름
						{
							몬스터찾음 := 1
							break
						}
					}
				}
				else
				{
					몬스터찾음 := 1
				}
			}

			gui,listview,몬스터리스트
			if (몬스터찾음 = 1)  ; 이 부분 이전에 블랙리스트를 체크
			{
				; 블랙리스트 ListView에 OID가 있는지 확인
				gui, listview, 블랙리스트
				loop % LV_GetCount()
				{
					gui, listview, 블랙리스트
					LV_GetText(블랙리스트_OID, A_Index, 6)  ; 6번째 항목에서 OID를 가져옴
					if (몬스터OID = 블랙리스트_OID && 블랙리스트_OID != "")  ; 블랙리스트에 OID가 있으면
					{
						몬스터찾음 := 0  ; 몬스터찾음을 0으로 설정
						break  ; 루프를 종료
					}
				}
			}
			if (몬스터찾음 = 1)
			{
				거리 := 새거리
				몬스터리스트선택 := A_Index
			}
		}
	}

	gui,listview,몬스터리스트
	몬스터리스트현재선택 := LV_GetNext(0)
	if (몬스터리스트선택 != 0 && 몬스터리스트현재선택 = 0)
	{
		gui, listview, 몬스터리스트
		LV_GetText(종류1, 몬스터리스트선택, 1)
		if (종류1 = "몬스터")
		{
			LV_Modify(0,"-Select")
			LV_Modify(몬스터리스트선택, "Select")
		}
	}

	gui,listview,몬스터리스트
	몬스터리스트현재선택 := LV_GetNext(0)
	if (몬스터리스트현재선택 != 0)
	{
		gui,listview,몬스터리스트
		몬스터리스트선택 := LV_GetNext(0)
		lv_gettext(현재타겟분류,몬스터리스트선택,1)
		lv_gettext(현재타겟차원,몬스터리스트선택,2)
		lv_gettext(현재타겟맵이름,몬스터리스트선택,3)
		lv_gettext(현재타겟맵번호,몬스터리스트선택,4)
		lv_gettext(현재타겟이름,몬스터리스트선택,5)
		lv_gettext(현재타겟OID,몬스터리스트선택,6)
		lv_gettext(현재타겟X,몬스터리스트선택,7)
		lv_gettext(현재타겟Y,몬스터리스트선택,8)
		lv_gettext(현재타겟Z,몬스터리스트선택,9)
		mem.write(0x00590730, 현재타겟OID, "UInt", aOffsets*)
		mem.write(0x00584C2C, 현재타겟OID, "UInt", aOffsets*)

		gui,listview,몬스터리스트

		현재타격번호 := mem.read(0x0058dad4,"UINT",0x1a5)
		;   sleep,10
		공격여부 := mem.read(0x0058DAD4, "UInt", 0x178, 0xEB)
		A_Delay := A_TickCount - 공격딜레이
		IsMoving := mem.read(0x0058EB1C, "UInt", 0x174)

		if ( 현재타겟OID != 마지막타겟OID )
		{
			마지막타겟OID := 현재타겟OID
			마지막타격번호 := mem.read(0x0058dad4,"UINT",0x1a5)
			메모리실행("공격하기")
			gui,listview,몬스터리스트
			ifinstring, 현재타겟이름, 스톤고렘
			{
				스톤고렘타겟횟수++
				SB_SetText("스톤고렘 - " 스톤고렘타겟횟수 "마리소탕" , 2)
			}
			else ifinstring, 현재타겟이름, 수탉
			{
				수탉타겟횟수++
				SB_SetText("수탉 - " 수탉타겟횟수 "마리소탕" , 2)
			}
			공격딜레이 := A_TickCount
			return
		}
		else if (공격여부 = 0 && A_Delay > 3000)
		{
			메모리실행("공격하기")
			;      sleep, 200
			공격딜레이 := A_TickCount
		}
		MLS_delay := A_TickCount - StartCount
		if (MLS_delay > 3000) ;블랙리스트에 등록할지 말지 결정
		{
			if ( 좌표X = 시작X && 좌표Y = 시작Y && 시작타격번호 = 현재타격번호)
			{
				KeyClick("AltR")
				gui,listview,몬스터리스트

				LV_Modify(0, "-Select")
				SB_SetTExt("몹에도달불가",2)
				gui,listview,블랙리스트
				블랙중복 := False
				loop % LV_GetCount()
				{
					lv_gettext(기존블랙OID,A_Index,6)
					if (기존블랙OID = 현재타겟OID)
					{
							블랙중복 := True
							break
					}
				}
				if (블랙중복 = False)
				{
					LV_Add("",현재타겟분류,현재타겟차원,현재타겟맵이름,현재타겟맵번호,현재타겟이름,현재타겟OID,현재타겟X,현재타겟Y,현재타겟Z,200)
				}
				StartCount := A_TickCount
			}
			else
			{
				시작타격번호 := mem.read(0x0058dad4,"UINT",0x1a5)
				시작X := mem.read(0x0058DAD4, "UInt", 0x10)
				시작Y := mem.read(0x0058DAD4, "UInt", 0x14)
				StartCount := A_TickCount
			}
		}
		return
	}

	if (스톤고렘타겟횟수 >= 31 && 특오자동교환여부 = 1)
	{
		;과도한 경쟁 예상, 공유시 삭제 필요
		특오교환:
		스톤고렘타겟횟수 := 0

		return
	}
}
if (아템먹기여부 = 1)
{
	gui,listview,아이템리스트
	아이템리스트선택 := LV_GetNext(0)
	if ( 아이템리스트선택 = 0 )
	{
		Loop % LV_GetCount()
		{
			LV_GetText(타겟_X, A_Index, 7)
			LV_GetText(타겟_Y, A_Index, 8)
			distanceX := Abs(타겟_X - 좌표X)
			distanceY := Abs(타겟_Y - 좌표Y)
			distanceXY := Abs( Abs(distanceX - distanceY) + distanceX)
			LV_Modify(A_Index,"Col12", distanceXY)
		}

		거리 := 100
		선택 := 0

		Loop % LV_GetCount()
		{
			LV_GetText(종류, A_Index, 1)
			LV_GetText(새거리, A_Index, 12)
			if (새거리 < 거리 && 종류 = "아이템" )
			{
				거리 := 새거리
				아이템리스트선택 := A_Index
			}
		}

		if (아이템리스트선택 != 0)
		{
			LV_Modify(0,"-Select")
			LV_Modify(아이템리스트선택, "Select")
		}
	}
	좌표X := mem.read(0x0058DAD4, "UInt", 0x10)
	좌표Y := mem.read(0x0058DAD4, "UInt", 0x14)
	좌표Z := mem.read(0x0058DAD4, "UInt", 0x18)
	IsMoving := mem.read(0x0058EB1C, "UInt", 0x174)
	맵번호 := mem.read(0x0058EB1C, "UInt", 0x10E)

	if (아이템리스트선택 != 0)
	{
		gui,listview,아이템리스트
		LV_GetText(종류, 아이템리스트선택, 1)

		if (종류 = "아이템")
		{
			gui,listview,아이템리스트
			LV_GetText(타겟_X, 아이템리스트선택, 7)
			LV_GetText(타겟_Y, 아이템리스트선택, 8)
			LV_GetText(타겟_Z, 아이템리스트선택, 9)
			LV_GetText(타겟_OID, 아이템리스트선택, 6)
			IsDestinationEmpty := True

			gui,listview,아이템리스트
			좌표X := mem.read(0x0058DAD4, "UInt", 0x10)
			좌표Y := mem.read(0x0058DAD4, "UInt", 0x14)
			좌표Z := mem.read(0x0058DAD4, "UInt", 0x18)
			if (좌표X = 타겟_X && 좌표Y = 타겟_Y)
			{
				if ( 맵번호 = 237 || 맵번호 = 1403 || 맵번호 = 2300 || 맵번호 = 3300 || 맵번호 =  3301 || 맵번호 =  11)
				{
					if(타겟_Z = 0)
					{
						keyclick("Space")
						sleep, 1
						keyclick("Space")
						sleep, 100
						keyclick("Tab")
						sleep, 100
						keyclick("AltR")
						return
					}
				}
			}
			else
			{
				gui,listview,아이템리스트
				줍줍할아이템순서 := LV_GetNext(0)
				LV_GetText(줍줍할아이템, 줍줍할아이템순서, 5)
				mem.writeString(0x005901E5, 줍줍할아이템, "UTF-16", aOffsets*)
				메모리권한변경및쓰기("아이템줍기실행")

				distanceX := Abs(타겟_X - 좌표X)
				distanceY := Abs(타겟_Y - 좌표Y)
				IsMoving := mem.read(0x0058EB1C, "UInt", 0x174)
				if(타겟_X > 0 && 타겟_Y > 0 && IsMoving = 0)
				{
					if(타겟_Z = 0 || 타겟_Z = 1)
					{
						keyclick("AltR")
						;sleep, 100
						if ( 맵번호 = 237 || 맵번호 = 1403 || 맵번호 = 2300 || 맵번호 = 3300 || 맵번호 =  3301 || 맵번호 =  11)
						{
							좌표입력(타겟_X,타겟_Y,타겟_Z)
							;sleep,30
							SB_SetText("자동이동11",4)
							메모리실행("좌표이동")
							return
						}
						else if (distance<14 && distanceY<6)
						{
							아이템 := mem.write(0x00590770, 타겟_OID, "UInt", aOffsets*)
							;sleep,30
							메모리실행("따라가기")
						}
						;sleep, 300
						IsMoving := mem.read(0x0058EB1C, "UInt", 0x174)
						if (isMoving != 0)
							return
						좌표입력(타겟_X,타겟_Y,타겟_Z)
						;sleep,30
						SB_SetText("자동이동12",4)
						메모리실행("좌표이동")

						;sleep,500
						return
					}
				}
			}
		}
	}
	else if (아이템리스트선택 = 0)
	{
		메모리권한변경및쓰기("아이템줍기정지")
	}
}

if (자동이동여부 = 1)
{
	Set_MoveSpeed(180)
	gui,listview,좌표리스트
	좌표리스트선택 := LV_GetNext(0)
	if (좌표리스트선택 = 0)
	좌표리스트선택 := 1
	LV_GetText(타겟_X, 좌표리스트선택, 4)
	LV_GetText(타겟_Y, 좌표리스트선택, 5)
	LV_GetText(타겟_Z, 좌표리스트선택, 6)

	if (abs(타겟_X - 좌표X) < 4 && abs(타겟_Y - 좌표Y) < 4 )
	{
		좌표리스트선택 := 좌표리스트선택 + 1
		if (좌표리스트선택 > LV_GetCount())
		{
			좌표리스트선택 := 1
		}
		gui,listview,좌표리스트
		LV_Modify(0,"-Select")
		LV_Modify(좌표리스트선택,"Select")
	}
	IsMoving := mem.read(0x0058EB1C, "UInt", 0x174)
	if(타겟_X > 0 && 타겟_Y > 0 && IsMoving = 0)
	{
		if(타겟_Z = 0 || 타겟_Z = 1)
		{
			gui,listview,신규몬스터리스트
			loop % LV_GetCount()
			{
				LV_GetText(몬스터_X, A_index, 7)
				LV_GetText(몬스터_y, A_index, 8)
				if (타겟_X = 몬스터_X && 타겟_Y = 몬스터_y)
				{
					타겟_X := 타겟_X + 1
					Random, rand, 1, 3
					타겟_X += rand - 2
					Random, rand, 1, 3
					타겟_Y += rand - 2
				}
			}
			gui,listview,신규플레이어리스트
			loop % LV_GetCount()
			{
				LV_GetText(몬스터_X, A_index, 7)
				LV_GetText(몬스터_y, A_index, 8)
				if (타겟_X = 몬스터_X && 타겟_Y = 몬스터_y)
				{
					타겟_X := 타겟_X + 1
					Random, rand, 1, 3
					타겟_X += rand - 2
					Random, rand, 1, 3
					타겟_Y += rand - 2
				}
			}
			좌표입력(타겟_X,타겟_Y,타겟_Z)
			;sleep,30
			SB_SetText("자동이동1",4)
			메모리실행("좌표이동")

			return
		}
	}
}

return
}

접속여부확인:
{
접속여부확인상태RunCount++
guicontrol, ,접속여부확인상태, %접속여부확인상태RunCount%

gui, submit, nohide
PT_Delay := A_TickCount - PT_Delays
if (자동파티여부 = 1 && PT_Delay > 60000)
{
	gosub, 원격파티하기
	PT_Delays := A_TickCount
}
if (자동재접속사용여부 = 1 && TargetTitle != "")
{
	ServerConnectionCheck := mem.readString(0x0017E574, 40, "UTF-16", aOffsets*)
	IfInString,ServerConnectionCheck,서버와의 연결이
	{
		mem.writeString(0x0017E574, "", "UTF-16", aOffsets*)
		KeyClick("Enter")
		sb_settext("ERROR-M-1",2)
		일랜시아점검필요 := True
		sleep,2000
		gosub, 일랜시아시작
		return
	}
	else IfWinExist,Microsoft Windows
	{
		WinClose
		sleep,2000
		gosub, 일랜시아시작
		return
	}
	else IfWinExist,Microsoft Visual C++ Runtime Library
	{
		WinClose
		sleep,2000
		gosub, 일랜시아시작
		return
	}
	else IfWinExist,ahk_exe WerFault.exe
	{
		CONTROLCLICK, Button2, ahk_exe WerFault.exe
		PROCESS, Close, WerFault.exe
		sleep,2000
		gosub, 일랜시아시작
		return
	}
	else IfWinExist, ahk_pid %TargetPid%
	{
		if DllCall("IsHungAppWindow", "UInt", WinExist())
		{
			PROCESS, Close, %jPID%
			sleep,2000
			gosub, 일랜시아시작
			return
		}
	}

	WINGETTEXT, WindowErrorMsg, ahk_class #32770
	IfInString,WindowErrorMsg,프로그램을 마치려면
	{
		CONTROLCLICK, Button1, ahk_class #32770
		sleep,500
		gosub, 일랜시아시작
		return
	}
	IfInString,WindowErrorMsg,작동이 중지되었습니다.
	{
		CONTROLCLICK, Button1, ahk_class #32770
		sleep,500
		gosub, 일랜시아시작
		return
	}
	IfWinNotExist,ahk_pid %TargetPid%
	{
		sb_settext("ERROR-M-2",2)
		일랜시아점검필요 := True
		sleep,500
		gosub, 일랜시아시작
		return
	}
}
return
}

;-------------------------------------------------------
;-------ListView 제어부---------------------------------
;-------------------------------------------------------
NPC리스트다운:
{
	return
저장위치 := a_scriptdir . "\SaveOf" . TargetTitle
temp_저장위치 := 저장위치 . "\DW_NPCList.ini"
urldownloadtofile, https:// , %temp_저장위치%
gui, listview, NPC리스트
Fileread,var, *P65001 %temp_저장위치%
;다운로드 -> 차원|번호|이름|OID
;ahk내 -> 분류|차원|맵이름|번호|이름|OID|X|Y|Z|우선순위|주소
for index, value in strsplit(var,"`n","`r")
{
	if value =
		continue
	row := []
	row.push("NPC")
	i := 1
	중복 := False
	loop, parse, value, %dlm%
	{
		if (i = 2)
		row.push("알수없음")
		if (i = 6)
		{
			gui,listview,NPC리스트
			loop % LV_GetCount()
			{
				lv_gettext(O_OID,A_INDEX,6)
				if (O_OID = a_loopfield && a_loopfield != "")
				중복 := True
			}
		}
		row.push(a_loopfield)
		i++
	}

	if (중복 = False && row[2] != "" && row[2] != " " )
	{
		LV_add("",row*)
	}
}
return
}

NPC리스트불러오기:
{
;type := 원하는아이템리스트
;type := 은행넣을아이템리스트
;type := 소각할아이템리스트
;type := 원하는몬스터리스트
type := NPC리스트
;Setting_RECORD(type,itemname*)
Gui, ListView, %type%
LV_Delete()
LoadItemData(type)
return
}

NPC리스트업로드:
{
;SQLITE을 사용하여 한줄씩 전송
;DB_URL := 'https://
;User_ID := ?ID=
;User_Auth := ?UAuth=H_elancia
;User_Pass := ?HC=
;Allowed_Code := ?AMSN=610209388402173299103857302017364
;filename :=
;method :=
return
}

NPC리스트리셋:
{
FileName := "NPCList.ini"
FileDelete, %FileName%
gui, listview, NPC리스트
LV_delete()
return
}

아이템읽어오기:
{
I_Delay := A_TickCount - 소지아이템리스트업데이트딜레이
if (I_Delay > 1000)
{
	소지아이템리스트업데이트딜레이 := A_TickCount
	gui,listview,소지아이템리스트
	Lv_delete()
	invenslot := 0
	오란의깃갯수 := 0
	라스의깃갯수 := 0
	정령의보석갯수 := 0
	식빵갯수 := 0
	특별한오란의깃갯수 := 0
	행운이깃든종이갯수 := 0
	생명의콩갯수 := 0
	리메듐갯수 := 0
	브리스갯수 := 0
	작은얼음조각갯수 := 0
	조개갯수 := 0
	약초갯수 := 0
	사슴고기갯수 := 0
	빛나는가루갯수 := 0
	빛나는나뭇가지갯수 := 0
	빛나는결정갯수 := 0
	독성포자해독약갯수 := 0
	loop, 50
	{
		SETFORMAT, integer, H
		invenslot += 4
		SETFORMAT, integer, D
		a := A_Index
		SETFORMAT, integer, H
		invenitem := mem.readString(0x0058DAD4, 50, "UTF-16", 0x178, 0xBE, 0x8, invenslot, 0x8, 0x8, 0x0)
		SETFORMAT, integer, D
		ItemCount := mem.read(0x0058DAD4, "Uint", 0x178, 0xBE, 0x8, invenslot, 0x8, 0x20)
		;if (invenitem = "브라키디움" || invenitem = "브리디움" || invenitem = "엘사리아" || invenitem = "다니움" || invenitem = "테사랏트" || invenitem = "마하디움")
		;{
		;    if(ItemCount>=20)
		;    {
		;        SetFormat, Integer, H
		;        합칠아이템순서 := A_Index
		;        sleep,10
		;        메모리권한변경및쓰기("정령석합치기")
		;        sleep,10
		;        ;메모리실행("마법사용")
		;        SetFormat, Integer, D
		;    }
		;}
		if (invenitem = "라스의깃")
		{
		라스의깃갯수 += ItemCount
		GuiControl,, 라스의깃수량, %라스의깃갯수%
		}
		else if (invenitem = "정령의보석")
		{
		정령의보석갯수 += ItemCount
		GuiControl,, 정령의보석수량, %정령의보석갯수%
		}
		else if (invenitem = "행운이깃든종이")
		{
		행운이깃든종이갯수 += ItemCount
		}
		else if (invenitem = "특별한오란의깃")
		{
		특별한오란의깃갯수 += ItemCount
		}
		else if (invenitem = "생명의콩")
		{
		생명의콩갯수  += ItemCount
		}
		else if (invenitem = "오란의깃")
		{
		오란의깃갯수  += ItemCount
		}
		else if (invenitem = "작은얼음조각")
		{
		작은얼음조각갯수 += ItemCount
		}
		else if (invenitem = "사슴고기")
		{
		사슴고기갯수 += ItemCount
		}
		else if (invenitem = "조개")
		{
		조개갯수 += ItemCount
		}
		else if (invenitem = "아라트(리메듐)")
		{
		리메듐갯수 += ItemCount
		}
		else if (invenitem = "아라트(브리스)")
		{
		브리스갯수 += ItemCount
		}
		else ifinstring, invenitem,약초
		{
		약초갯수 += ItemCount
		}
		else if (invenitem = "빛나는가루")
		{
		빛나는가루갯수 += ItemCount
		}
		else if (invenitem = "빛나는나뭇가지")
		{
		빛나는나뭇가지갯수 += ItemCount
		}
		else if (invenitem = "빛나는결정")
		{
		빛나는결정갯수 += ItemCount
		}
		else if (invenitem = "독성포자해독약")
		{
		독성포자해독약갯수 += ItemCount
		}
		else if (invenitem = "식빵")
		{
		식빵갯수 += ItemCount
		GuiControl,, 식빵수량, %식빵갯수%
		}

		if (invenitem = "독성포자해독약" && 독성포자해독약갯수 > 9)
			add_소각할아이템대기리스트(invenitem)

		gui, listview, 은행넣을아이템리스트
		Loop % LV_GetCount()
		{
			gui, listview, 은행넣을아이템리스트
			LV_GetText(아이템,A_index,1)
			if (아이템 != "") && ifinstring, invenitem, %아이템%
			{
				add_은행넣을아이템대기리스트(invenitem)
			}
		}
		gui, listview, 소각할아이템리스트
		Loop % LV_GetCount()
		{
			gui, listview, 소각할아이템리스트
			LV_GetText(아이템,A_index,1)
			if (아이템 != "" && invenitem = 아이템)
			{
				add_소각할아이템대기리스트(invenitem)
			}
		}
		gui,listview,소지아이템리스트
		if (invenitem != "" && invenitem != false )
			LV_add("",a,invenitem,ItemCount)
		SETFORMAT, integer, D
	}
}
return
}

원하는몬스터추가:
{
Gui, Submit, Nohide
type := "원하는몬스터리스트"
Setting_RECORD(type,원하는몬스터추가할몬스터명)
Gui, ListView, %type%
LV_Delete()
LoadItemData(type)
return
}

원하는몬스터삭제:
{
Gui, Submit, Nohide
gui, listview, 원하는몬스터리스트
SelectRowNum := 0
RowNumber = 0
loop
{
	RowNumber := LV_GetNext(RowNumber)
	if not RowNumber
		break
	SelectRowNum := RowNumber
}
LV_GetText(targetitem,SelectRowNum)
Setting_DELETE("원하는몬스터리스트", targetItem)
SB_SetText(targetItem " 삭제", 2)
Lv_Delete(SelectRowNum)
return
}

원하는아이템넣을아이템추가:
{
Gui, Submit, Nohide
type := "원하는아이템리스트"
Setting_RECORD(type,원하는아이템추가할아이템명)
Gui, ListView, %type%
LV_Delete()
LoadItemData(type)
return
}

원하는아이템넣을아이템삭제:
{
Gui, Submit, Nohide
gui, listview, 원하는아이템리스트
SelectRowNum := 0
RowNumber = 0
loop
{
	RowNumber := LV_GetNext(RowNumber)
	if not RowNumber
		break
	SelectRowNum := RowNumber
}
LV_GetText(targetitem,SelectRowNum)
Setting_DELETE("원하는아이템리스트", targetItem)
SB_SetText(targetItem " 삭제", 2)
Lv_Delete(SelectRowNum)
return
}

은행넣을아이템추가:
{
Gui, Submit, Nohide
type := "은행넣을아이템리스트"
Setting_RECORD(type,은행넣기추가할아이템명)
Gui, ListView, %type%
LV_Delete()
LoadItemData(type)
return
}

은행넣을아이템삭제:
{
gui, listview, 은행넣을아이템리스트
SelectRowNum := 0
RowNumber = 0
loop
{
	RowNumber := LV_GetNext(RowNumber)
	if not RowNumber
		break
	SelectRowNum := RowNumber
}
LV_GetText(targetitem,SelectRowNum)
Setting_DELETE("은행넣을아이템리스트", targetItem)
SB_SetText(targetItem " 삭제", 2)
Lv_Delete(SelectRowNum)
return
}

소각할아이템추가:
{
Gui, Submit, Nohide
type := "소각할아이템리스트"
Setting_RECORD(type,소각하기추가할아이템명)
Gui, ListView, %type%
LV_Delete()
LoadItemData(type)
return
}

소각할아이템삭제:
{
gui, listview, 소각할아이템리스트
SelectRowNum := 0
RowNumber = 0
loop
{
	RowNumber := LV_GetNext(RowNumber)
	if not RowNumber
		break
	SelectRowNum := RowNumber
}
LV_GetText(targetitem,SelectRowNum)
Setting_DELETE("소각할아이템리스트", targetItem)
SB_SetText(targetItem " 삭제", 2)
Lv_Delete(SelectRowNum)
return
}

;-------------------------------------------------------
;-------YouTube로 배우는 예제----------------------------
;-------------------------------------------------------

세르니카알파가기:
마을 := "세르니카"
목적차원 := "알파"
라깃사용하기(마을,목적차원)
return

세르니카베타가기:
마을 := "세르니카"
목적차원 := "베타"
라깃사용하기(마을,목적차원)
return

세르니카감마가기:
마을 := "세르니카"
목적차원 := "감마"
라깃사용하기(마을,목적차원)
return

포프레스네베타가기:
마을 := "포프레스네"
목적차원 := "베타"
라깃사용하기(마을,목적차원)
return

크로노시스베타가기:
마을 := "크로노시스"
목적차원 := "베타"
라깃사용하기(마을,목적차원)
return


블랙리스트추가메뉴:
{
if (rn=0)
return
MouseGetPos, musX, musY
Menu, CMenu, Show, %musX%,%musY%
return
}

목표리스트추가메뉴:
{
if (rn=0)
return
MouseGetPos, musX, musY
Menu, DMenu, Show, %musX%,%musY%
return
}

좌표리스트추가메뉴:
{
if (rn=0)
return
MouseGetPos, musX, musY
Menu, EMenu, Show, %musX%,%musY%
return
}

목표리스트_DO:
{
If (A_ThisMenuItem = "따라가기")
gosub,목표리스트_따라가기
If (A_ThisMenuItem = "공격하기")
gosub,목표리스트_공격하기
If (A_ThisMenuItem = "이동하기")
gosub,목표리스트_이동하기
If (A_ThisMenuItem = "삭제하기")
gosub,목표리스트_삭제하기
If (A_ThisMenuItem = "파티하기")
gosub,목표리스트_파티하기
If (A_ThisMenuItem = "접속차단")
gosub,목표리스트_섭팅하기
return
}

목표리스트_파티하기:
{
mem.write(0x0058FE20, C6, "UInt", aOffsets*)
메모리실행("파티걸기")
return
}

목표리스트_섭팅하기:
{
mem.write(0x00590B08, C6, "UInt", aOffsets*)
메모리실행("섭팅하기")
return
}

목표리스트_따라가기:
{
mem.write(0x00590770, C6, "UInt", aOffsets*)
메모리실행("따라가기")
return
}

목표리스트_공격하기:
{
mem.write(0x00590730, C6, "UInt", aOffsets*)
메모리실행("공격하기")
return
}

목표리스트_이동하기:
{
좌표입력(C7,C8,C9)
sleep,30
메모리실행("좌표이동")
return
}

목표리스트_삭제하기:
{
RowNumber = 0
loop
{
RowNumber := LV_GetNext(RowNumber)
if not RowNumber
break
SelectRowNum := RowNumber
}
Lv_Delete(SelectRowNum)
Return
}

목표리스트실행:
{
gui,listview,목표리스트
RN:=LV_GetNext(0)
if (rn=0)
return
Row := A_EventInfo
;LV_Add("", "플레이어", 차원, 맵이름, 맵번호, find_name, find_object_id, find_x, find_y, find_z)
LV_GetText(C1,row,1)
LV_GetText(C2,row,2)
LV_GetText(C3,row,3)
LV_GetText(C4,row,4)
LV_GetText(C5,row,5)
LV_GetText(C6,row,6)
LV_GetText(C7,row,7)
LV_GetText(C8,row,8)
LV_GetText(C9,row,9)
if (A_GuiEvent = "DoubleClick")
{

}
if A_GuiEvent = click
goto,목표리스트추가메뉴
if A_GuiEvent = Rightclick
goto,목표리스트추가메뉴
return
}

플레이어리스트실행:
{
gui,listview,플레이어리스트
RN:=LV_GetNext(0)
if (rn=0)
return
Row := A_EventInfo
;LV_Add("", "플레이어", 차원, 맵이름, 맵번호, find_name, find_object_id, find_x, find_y, find_z)
LV_GetText(C1,row,1)
LV_GetText(C2,row,2)
LV_GetText(C3,row,3)
LV_GetText(C4,row,4)
LV_GetText(C5,row,5)
LV_GetText(C6,row,6)
LV_GetText(C7,row,7)
LV_GetText(C8,row,8)
LV_GetText(C9,row,9)
if (A_GuiEvent = "DoubleClick")
{

}
if (A_GuiEvent = "DoubleClick")
{
gui,listview,플레이어리스트
}
if A_GuiEvent = click
{
gui,listview,플레이어리스트
goto,목표리스트추가메뉴
}
if A_GuiEvent = Rightclick
{
gui,listview,플레이어리스트
goto,목표리스트추가메뉴
}
return
}

아이템리스트실행:
{
gui,listview,아이템리스트
RN:=LV_GetNext(0)
if (rn=0)
return
Row := A_EventInfo
;LV_Add("", "플레이어", 차원, 맵이름, 맵번호, find_name, find_object_id, find_x, find_y, find_z)
LV_GetText(C1,row,1)
LV_GetText(C2,row,2)
LV_GetText(C3,row,3)
LV_GetText(C4,row,4)
LV_GetText(C5,row,5)
LV_GetText(C6,row,6)
LV_GetText(C7,row,7)
LV_GetText(C8,row,8)
LV_GetText(C9,row,9)
if (A_GuiEvent = "DoubleClick")
{
gui,listview,아이템리스트
}
if A_GuiEvent = click
{
gui,listview,아이템리스트
goto,목표리스트추가메뉴
}
if A_GuiEvent = Rightclick
{
gui,listview,아이템리스트
goto,목표리스트추가메뉴
}
return
}

몬스터리스트실행:
{
gui,listview,몬스터리스트
RN:=LV_GetNext(0)
if (rn=0)
return
Row := A_EventInfo
;LV_Add("", "플레이어", 차원, 맵이름, 맵번호, find_name, find_object_id, find_x, find_y, find_z)
LV_GetText(C1,row,1)
LV_GetText(C2,row,2)
LV_GetText(C3,row,3)
LV_GetText(C4,row,4)
LV_GetText(C5,row,5)
LV_GetText(C6,row,6)
LV_GetText(C7,row,7)
LV_GetText(C8,row,8)
LV_GetText(C9,row,9)
if (A_GuiEvent = "DoubleClick")
{
gui,listview,아이템리스트
}
if A_GuiEvent = click
{
gui,listview,몬스터리스트
goto,목표리스트추가메뉴
}
if A_GuiEvent = Rightclick
{
gui,listview,몬스터리스트
goto,목표리스트추가메뉴
}
return
}

블랙리스트실행:
{
gui,listview,블랙리스트
RN:=LV_GetNext(0)
if (rn=0)
return
Row := A_EventInfo
;LV_Add("", "플레이어", 차원, 맵이름, 맵번호, find_name, find_object_id, find_x, find_y, find_z)
LV_GetText(C1,row,1)
LV_GetText(C2,row,2)
LV_GetText(C3,row,3)
LV_GetText(C4,row,4)
LV_GetText(C5,row,5)
LV_GetText(C6,row,6)
LV_GetText(C7,row,7)
LV_GetText(C8,row,8)
LV_GetText(C9,row,9)
if (A_GuiEvent = "DoubleClick")
{

}
if A_GuiEvent = click
goto,블랙리스트추가메뉴
if A_GuiEvent = Rightclick
goto,블랙리스트추가메뉴
return
}

블랙리스트_따라가기:
{
mem.write(0x00590770, C6, "UInt", aOffsets*)
메모리실행("따라가기")
return
}

블랙리스트_공격하기:
{
mem.write(0x00590730, C6, "UInt", aOffsets*)
메모리실행("공격하기")
return
}

블랙리스트_이동하기:
{
좌표입력(C7,C8,C9)
sleep,30
메모리실행("좌표이동")
return
}

블랙리스트_파티하기:
{
mem.write(0x0058FE20, C6, "UInt", aOffsets*)
메모리실행("파티걸기")
return
}

블랙리스트_삭제하기:
{
RowNumber = 0
loop
{
RowNumber := LV_GetNext(RowNumber)
if not RowNumber
break
SelectRowNum := RowNumber
}
Lv_Delete(SelectRowNum)
Return
}

블랙리스트_DO:
{
If (A_ThisMenuItem = "따라가기")
gosub,블랙리스트_따라가기
If (A_ThisMenuItem = "공격하기")
gosub,블랙리스트_공격하기
If (A_ThisMenuItem = "이동하기")
gosub,블랙리스트_이동하기
If (A_ThisMenuItem = "삭제하기")
gosub,블랙리스트_삭제하기
If (A_ThisMenuItem = "파티하기")
gosub,블랙리스트_파티하기
return
}

;-------------------------------------------------------
;-------인터페이스영역-----------------------------------
;-------------------------------------------------------

ReloadGuiOptions:
{
if (TargetTitle = "")
return
for Index, List in Lists
{
	%List%_Count := 0
	for Index, Item in %List%
	%List%_Count++
}
저장위치 := a_scriptdir . "\SaveOf" . TargetTitle . "\saved_setting.ini"
IfExist %저장위치%
{
	For Index, List in Lists
	{
		for Index, Item in %List%
		{
			IniRead, %Item%, %저장위치%, %List%, %Item%
			temp_variable := %item%
			if (List = "DropDownList")
			{
				Control, ChooseString, %Item%, %temp_variable%
				GuiControl,, %Item%, |
				GuiControl,, %Item%, %temp_variable%||
				Temp_list := Item . "_DDLOptions"
				for Index, option in %Temp_list%
				{
					if (temp_variable != option)
					GuiControl,, %Item%, %option%
				}
			}
			else if (List = "EditList")
			{
				if (temp_variable = "" || temp_variable = ERROR || temp_variable = "ERROR" )
				{
					최대HP := mem.read(0x0058DAD4, "UInt", 0x178, 0x1F)
					최대MP := mem.read(0x0058DAD4, "UInt", 0x178, 0x23)
					if (item = "힐링포션사용제한")
					temp_variable := Floor(최대HP * 0.5)
					else if (item = "HP마을귀환사용제한")
					temp_variable := Floor(최대HP * 0.4)
					else if (item = "리메듐사용제한")
					temp_variable := Floor(최대HP * 0.7)
					else if (item = "마나포션사용제한")
					temp_variable := Floor(최대MP * 0.2)
					else if (item = "MP마을귀환사용제한")
					temp_variable := Floor(최대MP * 0.1)
					else if (item = "브렐사용제한")
					temp_variable := Floor(최대MP * 0.3)
					else if (item = "식빵사용제한")
					temp_variable := 1
					else
					temp_variable := 0
					GuiControl,,%Item%, %temp_variable%
				}
				else
					GuiControl,,%Item%, %temp_variable%
			}
			else
				GuiControl,,%Item%, %temp_variable%
		}
	}
}
return
}

SaveBeforeExit:
{
if (TargetTitle != "")
{
	저장위치 := a_scriptdir . "\SaveOf" . TargetTitle
	if !FileExist(저장위치)
	{
		temp_foldername := "SaveOf" . TargetTitle
		FileCreateDir, %temp_foldername%
	}
}
if (TargetTitle = "")
	return
for Index, List in Lists
{
	%List%_Count := 0
	for Index, Item in %List%
		%List%_Count++
}
저장위치 := a_scriptdir . "\SaveOf" . TargetTitle . "\saved_setting.ini"
For Index, List in Lists
{
	for Index, Item in %List%
	{
		Temp_Variable := %Item%
		if (Temp_Variable != "")
			IniWrite, %Temp_Variable%, %저장위치%, %List%, %Item%
	}
}
return
}

Tab:
{
GuiControlGet, CurrentTab, , Tab1
Gui, Color, FFFFFF
if (CurrentTab != 5)
{
	Gui, Show, w500 h442, %ThisWindowTitle%
	GuiControl, move, Tab1, w496 h416
}
else if (CurrentTab = 5)
{
	Gui, Show, w1000 h442, %ThisWindowTitle%
	GuiControl, move, Tab1, w996 h416
}
return
}

GuiClose:
{
gosub, SaveBeforeExit
ExitApp
}

ShowGui:
{
;600x400
Gui, Add, Tab2, vTab1 x2 y2 w496 h416 AltSubmit cBlack gTab, 기본|설정|아템|이동|검색|파티|기타|개발용
Gui, Font, S9 Arial ,
Gui, Color, FFFFFF
gui, tab, 1
;캐릭터선택영역
Gui, Add, GroupBox, x15 y30 w160 h180, 캐릭터 선택
Gui, Add, ListBox, x25 y50 w140 h130 g일랜시아선택 vElanciaTitle , %ElanTitles%
Gui, Add, Button, x35 y180 w120 h20 g일랜시아새로고침, 새로고침
;캐릭터정보영역
Gui, Add, GroupBox, x180 y30 w150 h180,
Gui, Add, Button, x190 y50 w130 h20 g일랜시아시작, 일랜시작
Gui, Add, checkbox, x190 y70 w20 h20 v자동재접속사용여부,
Gui, Add, Text, x210 y75 w100 h20, 자동재접속
Gui, Add, Text, x190 y95 w30 h20, 서버
Gui, Add, DropDownList, x220 y95 w100 h50 v메인캐릭터서버,엘||테스
Gui, Add, Text, x190 y120 w30 h20, 순서
Gui, Add, DropDownList, x220 y120 w100 h200 v메인캐릭터순서,1||2|3|4|5|6|7|8|9|10
Gui, Add, Text, x190 y145 w100 h20, 라스의깃
Gui, Add, Text, +Right x290 y145 w25 h20 v라스의깃수량,
Gui, Add, Text, x190 y165 w100 h20, 정령의보석
Gui, Add, Text, +Right x290 y165 w25 h20 v정령의보석수량,
Gui, Add, Text, x190 y185 w100 h20, 식빵
Gui, Add, Text, +Right x290 y185 w25 h20 v식빵수량,
;캐릭터상태영역
Gui, Add, GroupBox, x335 y30 w150 h180, 캐릭터 정보
Gui, Add, Text, x345 y50 w25 h20 ,STR
Gui, Add, Text, +Right x370 y50 w30 h20 vSTR,
Gui, Add, Text, x415 y50 w20 h20 ,AGI
Gui, Add, Text, +Right x440 y50 w30 h20 vAGI,
Gui, Add, Text, x345 y70 w25 h20 ,INT
Gui, Add, Text, +Right x370 y70 w30 h20 vINT,
Gui, Add, Text, x415 y70 w20 h20 ,VIT
Gui, Add, Text, +Right x440 y70 w30 h20 vVIT,

Gui, Add, Text, x345 y90 w70 h20 ,QUANTITY
Gui, Add, Text, +Right x420 y90 w50 h20 vQUANTITY,
Gui, Add, Text, x345 y110 w60 h20 ,GALRID
Gui, Add, Text, +Right x410 y110 w60 h20 vGALRID,
Gui, Add, Text, x345 y130 w60 h20 ,VOTE
Gui, Add, Text, +Right x410 y130 w60 h20 vVOTE,
Gui, Add, Text, x345 y150 w60 h20 ,FRAME
Gui, Add, Text, +Right x410 y150 w60 h20 vFRAME,

Gui, Add, Text, x345 y170 w130 h20 v좌표,
Gui, Add, Text, x345 y190 w130 h15 v맵,

Gui, Add, CheckBox, x15 y220 v아템먹기여부 disabled, 먹자(+채광)
Gui, Add, CheckBox, x105 y220 v자동사냥여부, 자동사냥
Gui, Add, CheckBox, x195 y220 v자동이동여부, 자동이동
Gui, Add, CheckBox, x285 y220 v무기사용여부, 1번무기유지

Gui, Add, GroupBox, x15 y240 w470 h165, 상태창
;HP 영역
Gui, Add, Text, x25 y260 w30 h20 ,HP
Gui, Add, Text, +Right x45 y260 w110 h20 vHP,

Gui, Add, Text, x25 y280 w140 h20,힐링포션 사용
Gui, Add, checkbox, x25 y295 w20 h20 v힐링포션사용여부,
Gui, Add, Edit, x50 y295 w55 h20 v힐링포션사용제한,
Gui, Add, DropDownList, x110 y295 w50 h60 v힐링포션사용단축키,5||6|7|8

Gui, Add, Text, x25 y320 w140 h20,마을귀환
Gui, Add, checkbox, x25 y335 w20 h20 vHP마을귀환사용여부,
Gui, Add, Edit, x50 y335 w55 h20 vHP마을귀환사용제한,
Gui, Add, DropDownList, x110 y335 w50 h60 v오란의깃사용단축키,5||6|7|8

Gui, Add, Text, x25 y360 w140 h20,리메듐사용
Gui, Add, checkbox, x25 y375 w20 h20 v리메듐사용여부,
Gui, Add, Edit, x50 y375 w55 h20 v리메듐사용제한,

;MP 영역
Gui, Add, Text, x180 y260 w30 h20 ,MP
Gui, Add, Text, +Right x200 y260 w110 h20 vMP,

Gui, Add, Text, x180 y280 w110 h20,마나포션 사용
Gui, Add, checkbox, x180 y295 w20 h20 v마나포션사용여부,
Gui, Add, Edit, x205 y295 w55 h20 v마나포션사용제한,
Gui, Add, DropDownList, x265 y295 w50 h60 v마나포션사용단축키,5|6||7|8

Gui, Add, Text, x180 y320 w140 h20,마을귀환
Gui, Add, checkbox, x180 y335 w20 h20 disabled vMP마을귀환사용여부,
Gui, Add, Edit, x205 y335 w55 h20 vMP마을귀환사용제한,

Gui, Add, Text, x180 y360 w140 h20,브렐사용
Gui, Add, checkbox, x180 y375 w20 h20 v브렐사용여부,
Gui, Add, Edit, x205 y375 w55 h20 v브렐사용제한,

;FP 영역
Gui, Add, Text, x335 y260 w30 h20 ,FP
Gui, Add, Text, +Right x355 y260 w110 h20 vFP,

Gui, Add, Text, x335 y280 w140 h20,식빵 사용
Gui, Add, checkbox, x335 y295 w20 h20 v식빵사용여부,
Gui, Add, Edit, x360 y295 w55 h20 v식빵사용제한,1
Gui, Add, DropDownList, x420 y295 w50 h60 v식빵사용단축키,9||

Gui, Add, Text, x335 y320 w140 h20,식빵구매
Gui, Add, checkbox, x335 y335 w20 h20 disabled v식빵구매여부,
Gui, Add, DropDownList, x360 y335 w110 h80 disabled v식빵구매마을,로랜시아||에필로리아|세르니카|크로노시스|포프레스네

Gui, Add, Text, x335 y360 w140 h20,골드바
Gui, Add, checkbox, x335 y375 w20 h20 disabled v골드바판매여부,
Gui, Add, Text, x355 y380 w30 h20 ,판매
Gui, Add, checkbox, x400 y375 w20 h20 disabled v골드바구매여부,
Gui, Add, Text, x420 y380 w30 h20 ,구매

gui, tab, 2
Gui, Add, GroupBox, x15 y30 w164 h170, 무기바꾸기
Gui, Add, Radio, x25 y50 v일무기 checked, 무바 X
Gui, Add, Radio, x25 y70 v일벗무바, 무기 + 주먹
Gui, Add, Radio, x25 y90 v이무기, 2무바
Gui, Add, Radio, x25 y110 v이벗무바, 2벗무바
Gui, Add, Radio, x25 y130 v삼무기, 3무바
Gui, Add, Radio, x25 y150 v삼벗무바, 3벗무바

Gui, Add, Text,,

Gui, Add, Radio, x115 y50 +g데미지핵 v퍼펙트 checked, 퍼핵
Gui, Add, Radio, x115 y70 +g데미지핵 v일반, 일반
Gui, Add, Radio, x115 y90 +g데미지핵 v미스, 미스

Gui, Add, GroupBox, x180 y30 w152 h240, 어빌사용
Gui, Add, checkbox, x190 y50 v대화사용, 대화
Gui, Add, checkbox, x190 y70 v명상사용, 명상
Gui, Add, checkbox, x190 y90 v더블어택사용, 덥택
Gui, Add, checkbox, x190 y110 v체력향상사용, 체향
Gui, Add, checkbox, x190 y130 v민첩향상사용, 민향
Gui, Add, checkbox, x190 y150 v활방어사용, 활방어
Gui, Add, checkbox, x190 y170 v마력향상사용, 마력향상
Gui, Add, checkbox, x190 y190 v마법방어향상사용, 마방향상
Gui, Add, checkbox, x190 y210 v훔치기사용, 훔치기
Gui, Add, checkbox, x190 y230 v훔쳐보기사용, 훔쳐보기
Gui, Add, checkbox, x190 y250 vSENSE사용, SENSE
Gui, Add, checkbox, x260 y50 v현혹사용, 현혹
Gui, Add, checkbox, x260 y70 v폭검사용, 폭검
Gui, Add, checkbox, x260 y90 v독침사용, 독침
Gui, Add, checkbox, x260 y110 v무기공격사용, 무기공격
Gui, Add, checkbox, x260 y130 v집중사용, 집중
Gui, Add, checkbox, x260 y150 v회피사용, 회피
Gui, Add, checkbox, x260 y170 v몸통찌르기사용, 몸찌

Gui, Add, GroupBox, x15 y205 w164 h65,퀵슬롯사용
Gui, Add, checkbox, x30 y225 v3번, 3번
Gui, Add, checkbox, x75 y225 v4번, 4번
Gui, Add, checkbox, x120 y225 v5번, 5번
Gui, Add, checkbox, x30 y245 v6번, 6번
Gui, Add, checkbox, x75 y245 v7번, 7번
Gui, Add, checkbox, x120 y245 v8번, 8번

Gui, Add, GroupBox, x15 y275 w82 h140,엘
Gui, Add, checkbox, x25 y295 v리메듐사용, 리메듐
Gui, Add, checkbox, x25 y315 v라리메듐사용, 라리메듐
Gui, Add, checkbox, x25 y335 v엘리메듐사용, 엘리메듐
Gui, Add, checkbox, x25 y355 v쿠로사용, 쿠로
Gui, Add, checkbox, x25 y375 v빛의갑옷사용, 빛의갑옷
Gui, Add, checkbox, x25 y395 v공포보호사용, 공포보호

coord_x := 15 + 82 * 1
Gui, Add, GroupBox, x%coord_x% y275 w82 h140,다뉴
coord_x := 25 + 82 * 1
Gui, Add, checkbox, x%coord_x% y295 v다라사용, 다라
Gui, Add, checkbox, x%coord_x% y315 v브렐사용, 브렐
Gui, Add, checkbox, x%coord_x% y335 v브레마사용, 브레마
Gui, Add, checkbox, x%coord_x% y355 v물의갑옷사용, 물의갑옷
Gui, Add, checkbox, x%coord_x% y375 v감속사용, 감속

coord_x := 15 + 82 * 2
Gui, Add, GroupBox, x%coord_x% y275 w77 h140,마하
coord_x := 25 + 82 * 2
Gui, Add, checkbox, x%coord_x% y295 v마스사용, 마스
Gui, Add, checkbox, x%coord_x% y315 v라크사용, 라크
Gui, Add, checkbox, x%coord_x% y335 v번개사용, 번개

coord_x := 15 + 82 * 3 - 5
Gui, Add, GroupBox, x%coord_x% y275 w77 h140,브리깃드
coord_x := 25 + 82 * 3 - 5
Gui, Add, checkbox, x%coord_x% y295 v브리스사용, 브리스
Gui, Add, checkbox, x%coord_x% y315 v파스티사용, 파스티

coord_x := 15 + 82 * 4 - 5 * 2
Gui, Add, GroupBox, x%coord_x% y275 w82 h140,브라키
coord_x := 25 + 82 * 4 - 5 * 2
Gui, Add, checkbox, x%coord_x% y295 v슈키사용, 슈키
Gui, Add, checkbox, x%coord_x% y315 v클리드사용, 클리드
Gui, Add, checkbox, x%coord_x% y335 v스톤스킨사용, 스톤스킨

coord_x := 15 + 82 * 5 - 5 * 2
Gui, Add, GroupBox, x%coord_x% y275 w77 h140,테스
coord_x := 25 + 82 * 5  - 5 * 2
Gui, Add, checkbox, x%coord_x% y295 v파라스사용, 파라스
Gui, Add, checkbox, x%coord_x% y315 v베네피쿠스사용, 베네
Gui, Add, checkbox, x%coord_x% y335 v저주사용, 저주

Gui, Add, GroupBox, x333 y30 w159 h60, 포레스트네NPC 대화
Gui, Add, checkbox, x348 y55 w15 h15 v포레스트네자동대화,
Gui, Add, dropdownlist, x373 y53 w60 v포레스트네자동대화딜레이, 10분||1분|5분|19분
Gui, Add, Button, x438 y52 h20 w45 h20 g포레스트네자동대화실행 v포레스트네자동대화실행중여부, 실행

Gui, Add, GroupBox, x333 y95 h175 w159,NPC리스트
Gui, Add, Button, x343 y110 h20 w40 gNPC리스트리셋, 리셋
Gui, Add, Button, x391 y110 h20 w40 gNPC리스트다운 , 다운
Gui, Add, Button, x439 y110 h20 w40 gNPC리스트업로드 disabled, 보고

Gui, Add, ListView, x336 y130 h135 w153 vNPC리스트 gNPC리스트실행 +altsubmit, 분류|차원|맵이름|번호|이름|OID|X|Y|Z|우선순위|주소|이미지
LV_ModifyCol(1,0)
LV_ModifyCol(2,40)
LV_ModifyCol(3,0)
LV_ModifyCol(4,0)
LV_ModifyCol(5,80)
LV_ModifyCol(6,10)
LV_ModifyCol(7,0)
LV_ModifyCol(8,0)
LV_ModifyCol(9,0)
LV_ModifyCol(10,0)
LV_ModifyCol(11,0)
LV_ModifyCol(12,20)

gui, tab, 3 ;기본|설정|아템|좌표|검색|기타
Gui, Add, text, x15 y33 w180 h20 ,원하는템(광물/줍줍)
Gui, Add, edit, x15 y50 w180 h20 v원하는아이템추가할아이템명,
Gui, Add, button, x15 y70 w85 h20 g원하는아이템넣을아이템추가, 추가
Gui, Add, button, x110 y70 w85 h20 g원하는아이템넣을아이템삭제, 삭제
Gui, Add, ListView, x15 y100 h200 w180 v원하는아이템리스트 +altsubmit, 원하는아이템
Gui, Add, ListView, x15 y300 h100 w180 v소지아이템리스트 +altsubmit, 순서|인벤토리아이템|수량
LV_ModifyCol(1,0)
LV_ModifyCol(2,120)
LV_ModifyCol(3,40)

Gui, Add, checkbox, x200 y30 w140 h20 v은행넣기활성화,은행넣기활성화
Gui, Add, edit, x200 y50 w140 h20 v은행넣기추가할아이템명,
Gui, Add, button, x200 y70 w65 h20 g은행넣을아이템추가, 추가
Gui, Add, button, x275 y70 w65 h20 g은행넣을아이템삭제, 삭제
Gui, Add, ListView, x200 y100 h200 w140 v은행넣을아이템리스트 +altsubmit,보관아이템
Gui, Add, ListView, x200 y300 h100 w140 v은행넣을아이템대기리스트 +altsubmit,대기리스트

Gui, Add, checkbox, x345 y30 w140 h20 v소각활성화,소각활성화
Gui, Add, edit, x345 y50 w140 h20 v소각하기추가할아이템명,
Gui, Add, button, x345 y70 w65 h20 g소각할아이템추가, 추가
Gui, Add, button, x420 y70 w65 h20 g소각할아이템삭제, 삭제
Gui, Add, ListView, x345 y100 h200 w140 v소각할아이템리스트 +altsubmit,소각아이템
Gui, Add, ListView, x345 y300 h100 w140 v소각할아이템대기리스트 +altsubmit,대기리스트

gui, tab, 4
Gui, Add, Text, x250 y30 h15 w80, 좌표리스트
Gui, Add, button, x370 y25 w80 h20 g좌표리스트추가 , 좌표추가
Gui, Add, ListView, x250 y45 h280 w215 v좌표리스트 g좌표리스트실행 +altsubmit, 번호|순번|맵이름|X|Y|Z
LV_ModifyCol(1,0)
LV_ModifyCol(2,40)
LV_ModifyCol(3,80)
LV_ModifyCol(4,30)
LV_ModifyCol(5,30)
LV_ModifyCol(6,30)

gui, tab, 5
Gui, Add, text, x15 y33 w180 h20 ,원하는몬스터
Gui, Add, edit, x15 y50 w180 h20 v원하는몬스터추가할몬스터명,
Gui, Add, button, x15 y70 w85 h20 g원하는몬스터추가, 추가
Gui, Add, button, x110 y70 w85 h20 g원하는몬스터삭제, 삭제
Gui, Add, ListView, x15 y100 h60 w240 v원하는몬스터리스트 +altsubmit, 사냥할몬스터
Gui, Add, Text, x15 y175 h15 w80, 목표 리스트
Gui, Add, ListView, x15 y190 h100 w240 v목표리스트 g목표리스트실행 +altsubmit, 분류|차원|맵이름|번호|이름|OID|X|Y|Z|주소|거리
LV_ModifyCol(1,40)
LV_ModifyCol(2,0)
LV_ModifyCol(3,0)
LV_ModifyCol(4,0)
LV_ModifyCol(5,80)
LV_ModifyCol(6,0)
LV_ModifyCol(7,30)
LV_ModifyCol(8,30)
LV_ModifyCol(9,30)
LV_ModifyCol(10,0)
LV_ModifyCol(11,20)
Gui, Add, Text, x15 y300 h15 w80, 블랙 리스트
Gui, Add, ListView, x15 y315 h100 w240 v블랙리스트 g블랙리스트실행 +altsubmit, 분류|차원|맵이름|번호|이름|OID|X|Y|Z|삭제카운트
LV_ModifyCol(1,0)
LV_ModifyCol(2,0)
LV_ModifyCol(3,0)
LV_ModifyCol(4,0)
LV_ModifyCol(5,100)
LV_ModifyCol(6,0)
LV_ModifyCol(7,30)
LV_ModifyCol(8,30)
LV_ModifyCol(9,30)
LV_ModifyCol(10,0)

x_coord := 15 + 240 + 5
Gui, Add, Text, x%x_coord% y30 h15 w80, 플레이어
Gui, Add, ListView, x%x_coord% y45 h250 w240 v플레이어리스트 +g플레이어리스트실행 +altsubmit, 분류|차원|맵이름|번호|이름|OID|X|Y|Z|주소|삭제카운트
LV_ModifyCol(1,40)
LV_ModifyCol(2,0)
LV_ModifyCol(3,0)
LV_ModifyCol(4,0)
LV_ModifyCol(5,80)
LV_ModifyCol(6,0)
LV_ModifyCol(7,30)
LV_ModifyCol(8,30)
LV_ModifyCol(9,30)
LV_ModifyCol(10,0)
LV_ModifyCol(11,0)
Gui, Add, ListView, x%x_coord% y295 h120 w240 v신규플레이어리스트 +altsubmit, 분류|차원|맵이름|번호|이름|OID|X|Y|Z|주소
LV_ModifyCol(1,40)
LV_ModifyCol(2,0)
LV_ModifyCol(3,0)
LV_ModifyCol(4,0)
LV_ModifyCol(5,80)
LV_ModifyCol(6,0)
LV_ModifyCol(7,30)
LV_ModifyCol(8,30)
LV_ModifyCol(9,30)
LV_ModifyCol(10,0)

x_coord := 15 + 240*2 + 5 *2
Gui, Add, Text, x%x_coord% y30 h15 w80, 몬스터
Gui, Add, ListView, x%x_coord% y45 h250 w240 v몬스터리스트 +g몬스터리스트실행 +altsubmit, 분류|차원|맵이름|번호|이름|OID|X|Y|Z|주소|삭제카운트|거리|이미지
LV_ModifyCol(1,40)
LV_ModifyCol(2,0)
LV_ModifyCol(3,0)
LV_ModifyCol(4,0)
LV_ModifyCol(5,80)
LV_ModifyCol(6,0)
LV_ModifyCol(7,30)
LV_ModifyCol(8,30)
LV_ModifyCol(9,30)
LV_ModifyCol(10,0)
LV_ModifyCol(11,0)
LV_ModifyCol(12,0)
LV_ModifyCol(13,0)
x_coord := 15 + 240*2 + 5 *2
Gui, Add, ListView, x%x_coord% y295 h120 w240 v신규몬스터리스트 +altsubmit, 분류|차원|맵이름|번호|이름|OID|X|Y|Z|주소
LV_ModifyCol(1,40)
LV_ModifyCol(2,0)
LV_ModifyCol(3,0)
LV_ModifyCol(4,0)
LV_ModifyCol(5,80)
LV_ModifyCol(6,0)
LV_ModifyCol(7,30)
LV_ModifyCol(8,30)
LV_ModifyCol(9,30)
LV_ModifyCol(10,0)
x_coord := 15 + 240*3 + 5 *3
Gui, Add, Text, x%x_coord% y30 h15 w80, 아이템
Gui, Add, ListView, x%x_coord% y45 h250 w240 v아이템리스트 +g아이템리스트실행 +altsubmit, 분류|차원|맵이름|번호|이름|OID|X|Y|Z|주소|삭제카운트|거리|이미지
LV_ModifyCol(1,40)
LV_ModifyCol(2,0)
LV_ModifyCol(3,0)
LV_ModifyCol(4,0)
LV_ModifyCol(5,80)
LV_ModifyCol(6,0)
LV_ModifyCol(7,30)
LV_ModifyCol(8,30)
LV_ModifyCol(9,30)
LV_ModifyCol(10,0)
LV_ModifyCol(11,0)
LV_ModifyCol(12,0)
LV_ModifyCol(13,0)
Gui, Add, ListView, x%x_coord% y295 h120 w240 v신규아이템리스트 +altsubmit, 분류|차원|맵이름|번호|이름|OID|X|Y|Z|주소
LV_ModifyCol(1,40)
LV_ModifyCol(2,0)
LV_ModifyCol(3,0)
LV_ModifyCol(4,0)
LV_ModifyCol(5,80)
LV_ModifyCol(6,0)
LV_ModifyCol(7,30)
LV_ModifyCol(8,30)
LV_ModifyCol(9,30)
LV_ModifyCol(10,0)

gui, tab, 6
x_coord := 15
Y_coord := 30
loop, 10
{
	Gui, Add, Checkbox, x%x_coord% y%y_coord% w20 h20 v%A_Index%번캐릭터사용여부,
	Y_coord += 30
}
x_coord := 35
Y_coord := 30
loop, 10
{
	Gui, Add, Edit, x%x_coord% y%y_coord% w100 h20 v%A_Index%번캐릭터명,
	Y_coord += 30
}
Gui, Add, Button, x%x_coord% y%y_coord% w100 h20 g파티캐릭터재확인, 새로고침
Y_coord += 30
Gui, Add, Checkbox, x15 y%y_coord% w20 h20 v자동파티여부,
Gui, Add, Button, x%x_coord% y%y_coord% w100 h20 g원격파티하기, 파티하기

gui, tab, 7  ;기본|설정|아템|좌표|검색|기타|번외
x_coord := 15
y_coord := 30
Gui, Add, GroupBox, x%x_coord% y%y_coord% w466 h110, 부의 축적 - 제작
x_coord := x_coord + 10
y_coord := y_coord + 23
Gui, Add, text, x%x_coord% y%y_coord% w80 h20, 은행넣을템
y_coord := y_coord - 8
x_coord := x_coord + 70
Gui, Add, EDIT, x%x_coord% y%y_coord% w100 h20 v넣을아이템,
x_coord := x_coord + 110
Gui, Add, button, x%x_coord% y%y_coord% w80 h20 g넣을아이템입력, 적용
x_coord := x_coord + 90
Gui, Add, button, x%x_coord% y%y_coord% w80 h20 g은행넣기테스트, 은행넣기
x_coord := x_coord + 90
Gui, Add, button, x%x_coord% y%y_coord% w80 h20 g은행빼기테스트, 은행빼기
y_coord := y_coord + 30
x_coord := 15 + 10
Gui, Add, DropDownlist, x%x_coord% y%y_coord% w260 h350 v지침서 +g지침서선택,||요리지침서 1-1 달걀 요리(Lv1)|요리지침서 1-2 식빵 요리(Lv1)|요리지침서 1-3 스프 요리(Lv1)|요리지침서 1-4 샌드위치 요리(Lv1)|요리지침서 1-5 초컬릿(Lv1)|요리지침서 1-6 송편(Lv1)|요리지침서 2-1 주먹밥 요리(Lv2)|요리지침서 2-2 오믈렛 요리(Lv2)|요리지침서 2-3 파이 요리(Lv2)|요리지침서 2-4 케익 요리(Lv2)|요리지침서 2-5 쥬스 요리(Lv2)|요리지침서 3-1 카레 요리(Lv3)|요리지침서 3-2 마늘 요리(Lv3)|요리지침서 4-1 비스킷 요리(Lv4)|요리지침서 4-2 닭고기 요리(Lv4)|요리지침서 4-3 돼지고기 요리(Lv4)|요리지침서 4-4 생선 요리(Lv4)|요리지침서 4-5 초밥 요리(Lv4)|요리지침서 5-1 팥빙수 요리(Lv5)|요리지침서 5-2 스파게티 요리(Lv5)|요리지침서 5-3 김치 요리(Lv5)|요리지침서 5-4 볶음밥 요리(Lv5)|스미스지침서 1-1 툴 수리(Lv1)|스미스지침서 1-2 검 수리(Lv1)|스미스지침서 1-3 창 수리(Lv1)|스미스지침서 1-4 기타 수리(Lv1)|스미스지침서 2-1 낚시대 제작(Lv2)|스미스지침서 2-2 픽액스 제작(Lv2)|스미스지침서 2-3 요리키트 제작(Lv2)|스미스지침서 2-4 미리온스캐너 제작(Lv2)|스미스지침서 2-5 스미스키트 제작(Lv2)|스미스지침서 2-6 재단키트 제작(Lv2)|스미스지침서 2-7 세공키트 제작(Lv2)|스미스지침서 2-8 관측키트 제작(Lv2)|스미스지침서 3-1 롱소드 제작(Lv3)|스미스지침서 3-2 바스타드소드 제작(Lv3)|스미스지침서 3-3 그레이트소드 제작(Lv3)|스미스지침서 3-4 대거 제작(Lv3)|스미스지침서 3-5 고태도 제작(Lv3)|스미스지침서 3-6 롱스피어 제작(Lv3)|스미스지침서 3-7 반월도 제작(Lv3)|스미스지침서 3-8 액스 제작(Lv3)|스미스지침서 3-9 햄머 제작(Lv3)|스미스지침서 3-10 우든보우 제작(Lv3)|스미스지침서 3-11 우든하프 제작(Lv3)|스미스지침서 3-12 시미터 제작(Lv3)|스미스지침서 4-1 아이언아머 제작(Lv4)|스미스지침서 4-2 폴드아머 제작(Lv4)|스미스지침서 4-3 스탠다드 아머 제작(Lv4)|스미스지침서 4-4 터틀아머 제작(Lv4)|스미스지침서 4-5 트로져아머 제작(Lv4)|스미스지침서 4-6 숄드레더 아머 제작(Lv4)|스미스지침서 4-7 밴디드레더 아머 제작(Lv4)|스미스지침서 4-8 밴디드아이언 아머 제작(Lv4)|스미스지침서 4-9 밴디드실버 아머 제작(Lv4)|스미스지침서 4-10 밴디드골드 아머 제작(Lv4)|스미스지침서 5-1 우든실드 제작(Lv5)|스미스지침서 5-2 실드 제작(Lv5)|스미스지침서 5-3 아이언실드 제작(Lv5)|스미스지침서 5-4 스톤실드 제작(Lv5)|스미스지침서 5-5 골든실드 제작(Lv5)|스미스지침서 6-1 올드헬멧 제작(Lv6)|재단지침서 1-1 반바지 수선(Lv1)|재단지침서 1-2 바지 수선(Lv1)|재단지침서 1-3 튜닉 수선(Lv1)|재단지침서 1-4 가니쉬 수선(Lv1)|재단지침서 1-5 레더슈즈 수선(Lv1)|재단지침서 1-6 레더아머 수선(Lv1)|재단지침서 2-1 반바지 제작(Lv2)|재단지침서 2-2 바지 제작(Lv2)|재단지침서 2-3 튜닉 제작(Lv2)|재단지침서 2-4 가니쉬 제작(Lv2)|재단지침서 2-5 레더슈즈 제작(Lv2)|재단지침서 2-6 레더아머 제작(Lv2)|재단지침서 2-7 수영모 제작(Lv2)|재단지침서 2-8 꽃무늬수영모 제작(Lv2)|재단지침서 3-1 울슈즈 제작(Lv3)|재단지침서 3-2 밤슈즈 제작(Lv3)|재단지침서 4-1 밧줄 제작(Lv4)|재단지침서 4-2 꽃무늬반바지 제작(Lv4)|재단지침서 4-3 꽃무늬바지 제작(Lv4)|재단지침서 4-4 꽃무늬치마 제작(Lv4)|재단지침서 4-5 줄무늬바지 제작(Lv4)|재단지침서 4-6 나팔바지 제작(Lv4)|재단지침서 4-7 칠부바지 제작(Lv4)|재단지침서 4-8 꽃무늬튜닉 제작(Lv4)|재단지침서 4-9 줄무늬튜닉 제작(Lv4)|재단지침서 4-10 터번 제작(Lv4)|재단지침서 4-11 볼륨업브라 제작(Lv4)|재단지침서 4-12 탑 제작(Lv4)|재단지침서 4-13 미니스커트 제작(Lv4)|재단지침서 4-14 햅번민소매 제작(Lv4)|재단지침서 4-15 햅번긴소매 제작(Lv4)|재단지침서 4-16 땡땡브라 제작(Lv4)|재단지침서 4-17 니혼모자 제작(Lv4)|재단지침서 5-1 튜닉 제작2(Lv5)|재단지침서 5-2 반바지 제작2(Lv5)|재단지침서 5-3 바지 제작2(Lv5)|재단지침서 5-4 가니쉬 제작2(Lv5)|재단지침서 5-5 레더아머 제작2(Lv5)|재단지침서 5-6 레더슈즈 제작2(Lv5)|재단지침서 5-7 울슈즈 제작2(Lv5)|재단지침서 5-8 밤슈즈 제작2(Lv5)|재단지침서 5-9 수영모 제작2(Lv5)|재단지침서 5-10 꽃무늬수영모 제작2(Lv5)|세공지침서 1-1 기초 세공(Lv1)|세공지침서 1-2 링 수리(Lv1)|세공지침서 1-3 네클리스 수리(Lv1)|세공지침서 2-1 브리디온 가공(Lv2)|세공지침서 2-2 다니온 가공(Lv2)|세공지침서 2-3 마하디온 가공(Lv2)|세공지침서 2-4 브라키디온 가공(Lv2)|세공지침서 2-5 브라키디온 가공(Lv2)|세공지침서 2-6 테사랏티온 가공(Lv2)|세공지침서 3-1 알티브리디온 가공(Lv3)|세공지침서 3-2 알티다니온 가공(Lv3)|세공지침서 3-3 알티마하디온 가공(Lv3)|세공지침서 3-4 알티브라키디온 가공(Lv3)|세공지침서 3-5 볼바디온 가공(Lv3)|세공지침서 3-6 테사리온 가공(Lv3)|세공지침서 4-1 브리시온(원석) 가공(Lv4)|세공지침서 4-2 다니시온(원석) 가공(Lv4)|세공지침서 4-3 마흐시온(원석) 가공(Lv4)|세공지침서 4-4 브라키시온(원석) 가공(Lv4)|세공지침서 4-5 엘리시온(원석) 가공(Lv4)|세공지침서 4-6 테스시온(원석) 가공(Lv4)|세공지침서 5-1 브리시온 가공(Lv5)|세공지침서 5-2 다니시온 가공(Lv5)|세공지침서 5-3 마흐시온 가공(Lv5)|세공지침서 5-4 브라키시온 가공(Lv5)|세공지침서 5-5 엘리시온 가공(Lv5)|세공지침서 5-6 테스시온 가공(Lv5)|세공지침서 6-1 아이언링 제작1(Lv6)|세공지침서 6-2 실버링 제작1(Lv6)|세공지침서 6-3 골드링 제작1(Lv6)|세공지침서 6-4 에메랄드링 제작1(Lv6)|세공지침서 6-5 사파이어링 제작1(Lv6)|세공지침서 6-6 투어마린링 제작1(Lv6)|세공지침서 6-7 브리디온링 제작1(Lv6)|세공지침서 6-8 다니온링 제작1(Lv6)|세공지침서 6-9 마하디온링 제작1(Lv6)|세공지침서 6-10 브라키디온링 제작1(Lv6)|세공지침서 6-11 엘사리온링 제작1(Lv6)|세공지침서 6-12 테사리온링 제작1(Lv6)|세공지침서 7-1 아이언네클리스 제작1(Lv7)|세공지침서 7-2 실버네클리스 제작1(Lv7)|세공지침서 7-3 골드네클리스 제작1(Lv7)|세공지침서 7-4 루비네클리스 제작1(Lv7)|세공지침서 7-5 상아네클리스 제작1(Lv7)|세공지침서 7-6 사파이어네클리스 제작1(Lv7)|세공지침서 7-7 펄네클리스 제작1(Lv7)|세공지침서 7-8 블랙펄네클리스 제작1(Lv7)|세공지침서 7-9 오레온 제작(Lv7)|세공지침서 7-10 세레온 제작(Lv7)|세공지침서 8-1 기초 가공1(Lv8)|세공지침서 8-2 기초 가공2(Lv8)|세공지침서 8-3 케이온 제작(Lv8)|세공지침서 9-1 초급 가공1(Lv9)|세공지침서 10-1 중급 가공1(Lv10)|세공지침서 11-1 고급 가공1(Lv11)|미용지침서 1-1 기초 염색(Lv1)|미용지침서 2-1 삭발 스타일(Lv2)|미용지침서 2-2 기본 스타일(Lv2)|미용지침서 2-3 펑크 스타일(Lv2)|미용지침서 2-4 레게 스타일(Lv2)|미용지침서 2-5 변형 스타일(Lv2)|미용지침서 2-6 더벅 스타일(Lv2)|미용지침서 2-7 바람 스타일(Lv2)|미용지침서 2-8 복고 스타일(Lv2)|미용지침서 2-9 자연 스타일(Lv2)|미용지침서 2-10 웨이브 스타일(Lv2)|미용지침서 2-11 세팅 스타일(Lv2)|미용지침서 2-12 폭탄 스타일(Lv2)|미용지침서 2-13 야자수 스타일(Lv2)|미용지침서 2-14 발랄 스타일(Lv2)|미용지침서 2-15 변형레게 스타일(Lv2)|미용지침서 2-16 올림 스타일(Lv2)|미용지침서 2-17 곱슬 스타일(Lv2)|미용지침서 2-18 미남스타일 변형(Lv2)|미용지침서 2-19 바가지 스타일(Lv2)|미용지침서 2-20 선녀 스타일(Lv2)|미용지침서 2-21 밤톨 스타일(Lv2)|미용지침서 2-22 귀족 스타일(Lv2)|미용지침서 2-23 드라마 스타일(Lv2)|미용지침서 2-24 앙증 스타일(Lv2)|미용지침서 2-25 트윈테일 스타일(Lv2)|미용지침서 3-1 검은눈 성형(Lv3)|미용지침서 3-2 파란눈 성형(Lv3)|미용지침서 3-3 찢어진눈 성형(Lv3)|목공지침서 1-1 소나무 가공(Lv1)|목공지침서 1-2 단풍나무 가공(Lv1)|목공지침서 1-3 참나무 가공(Lv1)|목공지침서 1-4 대나무 가공(Lv1)|목공지침서 2-1 토끼조각상 조각(Lv2)|목공지침서 2-2 암탉조각상 조각(Lv2)|목공지침서 2-3 수탉조각상 조각(Lv2)|목공지침서 2-4 푸푸조각상 조각(Lv2)|목공지침서 3-1 토끼상자 조각(Lv3)|목공지침서 3-2 푸푸상자 조각(Lv3)|목공지침서 3-3 오크상자 조각(Lv3)|목공지침서 3-4 고블린상자 조각(Lv3)|목공지침서 4-1 뗏목 제작(Lv4)|목공지침서 4-2 나무보트 제작(Lv4)|목공지침서 5-1 스노우보드 제작(Lv5)|목공지침서 5-2 썰매 제작(Lv5)|연금술지침서 1-1 힐링포션 제작(Lv1)|연금술지침서 1-2 마나포션 제작(Lv1)|연금술지침서 1-3 단검용독 제작(Lv1)|연금술지침서 2-1 스피드포션(1ml) 제작(Lv2)|연금술지침서 2-2 스피드포션(2ml) 제작(Lv2)|연금술지침서 2-3 스피드포션(3ml) 제작(Lv2)|연금술지침서 2-4 스피드포션(4ml) 제작(Lv2)|연금술지침서 2-5 스피드포션(5ml) 제작(Lv2)|연금술지침서 2-6 스피드포션(6ml) 제작(Lv2)|연금술지침서 2-7 체력향상포션(1ml) 제작(Lv2)|연금술지침서 2-8 체력향상포션(2ml) 제작(Lv2)|연금술지침서 2-9 체력향상포션(3ml) 제작(Lv2)|연금술지침서 2-10 체력향상포션(4ml) 제작(Lv2)|연금술지침서 2-11 체력향상포션(5ml) 제작(Lv2)|연금술지침서 2-12 체력향상포션(6ml) 제작(Lv2)|연금술지침서 3-1 주괴 제작(Lv3)
x_coord := x_coord + 90 + 90 + 90
Gui, Add, button, x%x_coord% y%y_coord% w80 h20 g핵지침서사용, 지침서 핵
x_coord := x_coord + 90
Gui, Add, button, x%x_coord% y%y_coord% w80 h20 g게임내지침서사용, 원래지침서
y_coord := y_coord + 30
x_coord := 15 + 10
Gui, Add, button, x%x_coord% y%y_coord% w125 h20 g상인어빌수련, 제작 - 재료소모X
x_coord := 15 + 10 + 125+10
Gui, Add, button, x%x_coord% y%y_coord% w125 h20 g상인단순제작, 제작 - 단순클릭
x_coord := 15 + 10 + 90 * 4
Gui, Add, button, x%x_coord% y%y_coord% w80 h20 g중지, 중지
x_coord := 15
y_coord := 150
Gui, Add, GroupBox, x%x_coord% y%y_coord% w466 h120, 끝없는 모험
x_coord := 25
y_coord := 175
Gui, Add, button, x%x_coord% y%y_coord% w80 h20 g길탐수련, 길탐수련
x_coord := x_coord + 90
Gui, Add, button, x%x_coord% y%y_coord% w80 h20 , 배달수련
x_coord := x_coord + 90
Gui, Add, button, x%x_coord% y%y_coord% w80 h20 , 밥통작
x_coord := x_coord + 90
Gui, Add, button, x%x_coord% y%y_coord% w80 h20 , 덥탭수련
x_coord := x_coord + 90
Gui, Add, button, x%x_coord% y%y_coord% w80 h25 g포남링교환, 포남링교환
y_coord := 175+30
x_coord := 25
Gui, Add, button, x%x_coord% y%y_coord% w80 h20 g특오교환,특오교환
x_coord := x_coord + 90
Gui, Add, button, x%x_coord% y%y_coord% w80 h20 g행운장매수, 행깃구매
x_coord := x_coord + 90
Gui, Add, button, x%x_coord% y%y_coord% w80 h20 , 가루교환
x_coord := x_coord + 90
Gui, Add, button, x%x_coord% y%y_coord% w80 h20 g수리하기, 수리하기
x_coord := x_coord + 90
Gui, Add, button, x%x_coord% y%y_coord% w80 h20 ,
y_coord := 175+30+30
x_coord := 25
Gui, Add, button, x%x_coord% y%y_coord% w80 h20 , ;리메듐 얻기
x_coord := x_coord + 90
Gui, Add, button, x%x_coord% y%y_coord% w80 h20 , ;브리스 얻기
x_coord := x_coord + 90
Gui, Add, button, x%x_coord% y%y_coord% w80 h20 , ;슈키 얻기
x_coord := x_coord + 90
Gui, Add, button, x%x_coord% y%y_coord% w80 h20 , ;다라 얻기
x_coord := x_coord + 90
Gui, Add, button, x%x_coord% y%y_coord% w80 h20 , ;클리드 얻기
y_coord := 175+30+30+40
x_coord := 15
Gui, Add, GroupBox, x%x_coord% y%y_coord% w466 h130, 기타

x_coord := x_coord + 90
y_coord := 175+30+30+30+30
x_coord := 25
Gui, Add, checkbox, x%x_coord% y%y_coord% w80 h20 v특오자동교환여부, 특오교환
x_coord := x_coord + 90
Gui, Add, button, x%x_coord% y%y_coord% w80 h20 g세르니카베타가기, 세르베타
x_coord := x_coord + 90
Gui, Add, button, x%x_coord% y%y_coord% w80 h20 g크로노시스베타가기, 크로베타
x_coord := x_coord + 90
Gui, Add, button, x%x_coord% y%y_coord% w80 h20 g포프레스네베타가기, 포프베타
x_coord := x_coord + 90
Gui, Add, EDIT, x%x_coord% y%y_coord% w80 h20 ,
y_coord := 175+30+30+30+30+25
x_coord := 25
Gui, Add, checkbox, x%x_coord% y%y_coord% w80 h20 v행깃구매여부, 행깃구매
x_coord := x_coord + 90
Gui, Add, button, x%x_coord% y%y_coord% w80 h20 g세르니카감마가기, 세르감마
x_coord := x_coord + 90
Gui, Add, button, x%x_coord% y%y_coord% w80 h20,
x_coord := x_coord + 90
Gui, Add, button, x%x_coord% y%y_coord% w80 h20 ,
x_coord := x_coord + 90
Gui, Add, button, x%x_coord% y%y_coord% w80 h20 ,
y_coord := 175+30+30+30+30+25+25
x_coord := 25
Gui, Add, checkbox, x%x_coord% y%y_coord% w80 h20 v라깃구매여부, 라깃구매
x_coord := x_coord + 90
Gui, Add, Button, x%x_coord% y%y_coord% w80 h20 g라깃구매, 라깃구매
x_coord := x_coord + 90
Gui, Add, button, x%x_coord% y%y_coord% w80 h20 g식빵구매, 식빵구매
x_coord := x_coord + 90
Gui, Add, button, x%x_coord% y%y_coord% w80 h20 g무기수리강제, 무기수리
x_coord := x_coord + 90
Gui, Add, button, x%x_coord% y%y_coord% w80 h20,
y_coord := 175+30+30+30+30+25+25+25
x_coord := 25
Gui, Add, checkbox, x%x_coord% y%y_coord% w80 h20 ,
x_coord := x_coord + 90
Gui, Add, button, x%x_coord% y%y_coord% w80 h20 ,
x_coord := x_coord + 90
Gui, Add, button, x%x_coord% y%y_coord% w80 h20 ,
x_coord := x_coord + 90
Gui, Add, button, x%x_coord% y%y_coord% w80 h20
x_coord := x_coord + 90
Gui, Add, button, x%x_coord% y%y_coord% w80 h20

gui, tab, 8 ;기본|설정|아템|좌표|검색|기타
Gui, Add, Checkbox, x25 y50 w140 h20 v보조윈도우 , 보조윈도우
Gui, Add, button, x25 y70 w140 h20 g보조윈도우 , 보조윈도우
Gui, Add, EDIT, x25 y90 w140 h20 vMultiplyer ,
Gui, Add, EDIT, x25 y110 w140 h20 vNPC_MSG_ADR ,
Gui, Add, EDIT, x25 y130 w140 h20 vResult_Msg_Addr ,
Gui, Add, EDIT, x25 y150 w140 h20 v상승어빌 ,
Gui, Add, EDIT, x25 y170 w140 h20 v상승어빌주소 ,
Gui, Add, EDIT, x25 y190 w140 h20 v마지막사냥장소 ,
Gui, Add, EDIT, x25 y210 w140 h20 v수련용길탐색딜레이,


Gui, Add, text, x325 y50 w140 h20 v메모리_주변검색상태 , 메모리_주변검색
Gui, Add, text, x325 y70 w140 h20 v재접속횟수기록 ,
Gui, Add, text, x325 y90 w140 h20 v접속여부확인상태 , 접속여부확인
Gui, Add, text, x325 y110 w140 h20 v기타동작상태 , 기타동작
Gui, Add, text, x325 y130 w140 h20 v스킬사용상태 , 스킬사용상태
Gui, Add, text, x325 y150 w140 h20 v무기자동바꾸기상태 , 무기자동바꾸기상태
Gui, Add, text, x325 y170 w140 h20 v행운장매수상태 , 행운장매수상태
Gui, Add, text, x325 y190 w140 h20 v현재TargetTitle , 현재TargetTitle
Gui, Add, text, x325 y210 w150 h20 v시작시간, 시작시간
Gui, Add, text, x325 y230 w100 h20 v시작체력 , 시작체력
Gui, Add, text, x325 y250 w100 h20 v마을귀환이유, 마을귀환이유

Gui, Add, text, x225 y50 w100 h20  , 메모리검색
Gui, Add, text, x225 y70 w100 h20 , 재접속
Gui, Add, text, x225 y90 w100 h20  , 접속여부확인
Gui, Add, text, x225 y110 w100 h20  , 기타동작
Gui, Add, text, x225 y130 w100 h20  , 스킬사용
Gui, Add, text, x225 y150 w100 h20  , 무기바꾸기
Gui, Add, text, x225 y170 w100 h20  , 행운장매수
Gui, Add, text, x225 y190 w100 h20  , TargetTitle
Gui, Add, text, x225 y210 w100 h20  , 시작시간
Gui, Add, text, x225 y230 w100 h20  , 시작체력
Gui, Add, text, x225 y250 w100 h20  , 마을귀환이유


Gui, Add, button, x15 y275 w150 h20 g어빌리티읽어오기 , 어빌리티읽어오기
Gui, Add, ListView, x15 y295 h100 w235 v어빌리티리스트 +altsubmit, 분류|순서|이름|그레이드|어빌리티
LV_ModifyCol(1,0)
LV_ModifyCol(2,0)
LV_ModifyCol(3,100)
LV_ModifyCol(4,20)
LV_ModifyCol(5,50)

Gui, Add, button, x251 y275 w150 h20 g마법읽어오기 , 마법읽어오기
Gui, Add, ListView, x251 y295 h100 w235 v마법리스트 +altsubmit, 분류|순서|이름|그레이드|어빌리티
LV_ModifyCol(1,0)
LV_ModifyCol(2,0)
LV_ModifyCol(3,100)
LV_ModifyCol(4,20)
LV_ModifyCol(5,50)

Gui, Add, StatusBar,, 상태바1
SB_SetParts(100, 200, 130, 80)
Gui, Show, w500 h442, %ThisWindowTitle%  ; GUI를 보이게 함

Menu, CMenu, Add,
Menu, CMenu, Add, 따라가기         , 블랙리스트_DO
Menu, CMenu, Add,
Menu, CMenu, Add,
Menu, CMenu, Add, 공격하기         , 블랙리스트_DO
Menu, CMenu, Add,
Menu, CMenu, Add,
Menu, CMenu, Add, 이동하기         , 블랙리스트_DO
Menu, CMenu, Add,
Menu, CMenu, Add,
Menu, CMenu, Add, 파티하기         , 블랙리스트_DO
Menu, CMenu, Add,
Menu, CMenu, Add,
Menu, CMenu, Add, 삭제하기         , 블랙리스트_DO
Menu, CMenu, Add,

Menu, DMenu, Add,
Menu, DMenu, Add, 따라가기         , 목표리스트_DO
Menu, DMenu, Add,
Menu, DMenu, Add,
Menu, DMenu, Add, 공격하기         , 목표리스트_DO
Menu, DMenu, Add,
Menu, DMenu, Add,
Menu, DMenu, Add, 이동하기         , 목표리스트_DO
Menu, DMenu, Add,
Menu, DMenu, Add,
Menu, DMenu, Add, 파티하기         , 목표리스트_DO
Menu, DMenu, Add,
Menu, DMenu, Add,
Menu, DMenu, Add, 삭제하기         , 목표리스트_DO
Menu, DMenu, Add,
Menu, DMenu, Add,
Menu, DMenu, Add, 접속차단         , 목표리스트_DO
Menu, DMenu, Add,

Menu, EMenu, Add,
Menu, EMenu, Add, 이동하기         , 좌표리스트_DO
Menu, EMenu, Add,
Menu, EMenu, Add,
Menu, EMenu, Add, 수정하기         , 좌표리스트_DO
Menu, EMenu, Add,
Menu, EMenu, Add,
Menu, EMenu, Add, 삭제하기         , 좌표리스트_DO
Menu, EMenu, Add,
}
Fill:
{
if (TargetTitle != "")
{
	저장위치 := a_scriptdir . "\SaveOf" . TargetTitle
	if FileExist(저장위치)
	{
		types := ["원하는아이템리스트", "은행넣을아이템리스트","소각할아이템리스트","원하는몬스터리스트","NPC리스트"]
		for index, type in types
		{
			Gui, ListView, %type%
			LV_Delete()
			LoadItemData(type)
		}

		Gui, listview, 좌표리스트
		LV_Delete()
		LoadCoordData()

		for Index, Item in EditList
		{
			temp_variable := %item%
			최대HP := mem.read(0x0058DAD4, "UInt", 0x178, 0x1F)
			최대MP := mem.read(0x0058DAD4, "UInt", 0x178, 0x23)
			if (item = "힐링포션사용제한")
			temp_variable := Floor(최대HP * 0.5)
			else if (item = "HP마을귀환사용제한")
			temp_variable := Floor(최대HP * 0.4)
			else if (item = "리메듐사용제한")
			temp_variable := Floor(최대HP * 0.7)
			else if (item = "마나포션사용제한")
			temp_variable := Floor(최대MP * 0.2)
			else if (item = "MP마을귀환사용제한")
			temp_variable := Floor(최대MP * 0.1)
			else if (item = "브렐사용제한")
			temp_variable := Floor(최대MP * 0.3)
			else if (item = "식빵사용제한")
			temp_variable := 1
			else
			temp_variable := 0
			GuiControl,,%Item%, %temp_variable%
		}
	}
}
Return
}
