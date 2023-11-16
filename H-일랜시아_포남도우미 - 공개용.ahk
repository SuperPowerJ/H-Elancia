;-----------------------------------------------------
;제작자: DCINSIDE 일랜시아 갤러리의 압둘핫산
;프로젝트명: H-Elancia
;-----------------------------------------------------


Global ThisWindowTitle := "H 매크로 - 잠수시 엘의축복은 필수입니다."

if not A_IsAdmin {
	MsgBox, 관리자 권한으로 실행해주세요
	ExitApp
}

;{ Autohotkey 옵션 부여
#SingleInstance, off
#NoEnv
#Persistent
#KeyHistory 0
#NoTrayIcon
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
Setworkingdir,%a_scriptdir%
;}

gosub, 초기항목선언
gosub, ShowGui
gosub, 메인루프
return

;-------------------------------------------------------
;-------초기값 설정부(변수설정)---------------------------
;-------------------------------------------------------
;{
초기항목선언:
;{

;전체 작동 및 작동중지 가능한 옵션
GLOBAL Coin := False

;옵션 리스트 구분
Lists := [ "CheckBoxList", "DropDownList", "EditList", "RadioButton" ]
;사용된 옵션들
CheckBoxList := ["수련길탐딜레이","이동속도사용","게임배속사용","길탐색책사용","원거리타겟","리메듐타겟","오란의깃사용여부","길탐색1번사용여부","길탐색2번사용여부","길탐색3번사용여부","길탐색4번사용여부","길탐색5번사용여부","자동재접속사용여부","힐링포션사용여부", "HP마을귀환사용여부", "리메듐사용여부", "마나포션사용여부", "MP마을귀환사용여부", "브렐사용여부", "식빵사용여부", "식빵구매여부", "골드바판매여부", "골드바구매여부", "대화사용", "명상사용", "더블어택사용", "체력향상사용", "민첩향상사용", "활방어사용", "마력향상사용", "마법방어향상사용", "3번", "4번", "5번", "6번", "7번", "8번", "은행넣기활성화", "소각활성화","아템먹기여부","자동이동여부", "훔치기사용", "훔쳐보기사용", "Sense사용", "자동사냥여부", "무기사용여부","특오자동교환여부","행깃구매여부","라깃구매여부","독침사용","현혹사용","폭검사용","무기공격사용","집중사용","회피사용","몸통찌르기사용","리메듐사용","라리메듐사용","엘리메듐사용","쿠로사용","빛의갑옷사용","공포보호사용","다라사용","브렐사용","브레마사용","물의갑옷사용","감속사용","마스사용","라크사용","번개사용","브리스사용","파스티사용","슈키사용","클리드사용","스톤스킨사용","파라스사용","베네피쿠스사용","저주사용","자동파티여부", "포레스트네자동대화","RemoveArmor사용","좀비몹감지", "위치고정", "배경제거", "캐릭제거","버스기사모드","나프사용","제작이동","자동그레이드"]
SpellList := ["나프", "마스","리메듐","라리메듐","엘리메듐","쿠로","빛의갑옷","공포보호","다라","브렐","브레마","물의갑옷","감속","라크","번개","브리스","파스티","슈키","클리드","스톤스킨","파라스","베네피쿠스","저주"]
DropDownList := ["오란의깃마을","길탐색1번목적지", "길탐색2번목적지", "길탐색3번목적지", "길탐색4번목적지", "길탐색5번목적지", "오란의깃단축키", "길탐색책단축키", "메인캐릭터서버", "메인캐릭터순서", "힐링포션사용단축키", "마나포션사용단축키", "식빵사용단축키", "식빵구매마을" ,"지침서", "오란의깃사용단축키", "포레스트네자동대화딜레이","CurrentMode","링단축키"]
EditList := ["원거리타겟아이디","리메듐타겟아이디","힐링포션사용제한", "HP마을귀환사용제한", "MP마을귀환사용제한", "리메듐사용제한", "마나포션사용제한", "브렐사용제한", "식빵사용제한", "MP마을귀환사용여부", "넣을아이템","Multiplyer","NPC_MSG_ADR" ,"마지막사냥장소", "수련용길탐색딜레이", "NPC대화딜레이", "MoveSpeed", "게임배속", "특수리메듐타겟OID","수동레벨기입","수리소야이름","수리소야아이템순서","수리소야아이템갯수"]
공격어빌 := ["격투", "봉", "검", "창", "활", "스태프", "현금", "도", "도끼", "단검"] ; 배열 내부에 검사하고 싶은 20개의 항목을 넣습니다.
마통작마법 := ["리메듐","엘리메듐","라리메듐","브렐","마스","마하","엘","다뉴"]
;게임내 파티 플레이어용 GUI 이름들
loop, 10
{
	temp := A_Index
	temp .= "번캐릭터사용여부"
	EditList.push(temp)
	temp := A_Index
	temp .= "번캐릭터명"
	EditList.push(temp)
}
loop, 18
{
	마법이름 := "마법" . A_index . "_이름"
	EditList.push(마법이름)
}
loop, 72
{
	어빌이름 := "어빌리티" . A_index . "_이름"
	EditList.push(어빌이름)
}
;GUI용 이름들
RadioButton := ["주먹", "일무기", "이벗무바", "퍼펙트", "일반", "미스", "차원결정유지","차원결정알파","차원결정베타","차원결정감마","수리","회복","소야수리"]
CommonSkillList := ["대화","명상"]
NormalSkillList := ["더블어택","체력향상","민첩향상","활방어","마력향상","마법방어향상","회피", "집중"]
TargetSkillList := ["훔치기","훔쳐보기","Sense","현혹","폭검","독침","무기공격"]
SkillListA := ["훔치기","훔쳐보기","Sense","현혹","폭검","독침","무기공격","더블어택","체력향상","민첩향상","활방어","마력향상","마법방어향상","집중","회피","대화","명상","몸통지르기","RemoveArmor"]

;몬스터 / NPC / 펫 / 로랜시아간판 / 에필로리아 애완동물구분용
게임내고용상인들 := ["의소야","의터그","의네시","의미피엘","의엘가노","의휘리스", "의Nesi"]
게임내NPC이미지 := [131,83,137]
게임내NPC들 := ["대장로","성향안내","장로","모험가","초보모험가","요리사","초보요리사","사냥꾼","초보무도가","세크티","콥","미너터","카리스","행운장","길드기","길드예선전보로1","길드예선전보로2","길드예선전보로3","길드예선전보로4","길드예선전보로5","길드예선전보로6","길드예선전보로7","길드예선전보로8","우물지기","우물지킴이","파미","실루엣","케이","휴","에레노아","길드만들기","라드","예절보로","할아버지","레나","초브","칼라스","브라키의여전사","테레즈","루비","오크왕자","슈","카딜라","나무보로","이사크","미소니","성궁사","수련장","그레파","미용바니","티포네","홀리","올드스미스","테디","피니","큐트","키드니","스텔라","실비아","네루아","사라","오블로","메티니","무타이","성검사","커스피스","쿠니퍼","라체","지올라","플린","헬러","브레너","에드가","두갈","아이렌","케드마","제프","젠","소니아","아바","네시아","래리","마리오","빈","렉스","다바트","코바니","플라노","미너스","토리온","브로이","카멘","카로에","시상보로","견습미용사","할머니","미스토","브라키의여전사","그라치","드리트","레시트","로크","메크","스타시","스테티나","이스카","호디니","베니","은행가드","파이","샤네트","코페","아일리아","퀘이드","레야","싱","유키오","이시","앨리아","오바","테론","윌라","페툴라","스티븐","우리안","빅터","리프","미네티","피트","비엔","칸느","포럼","콘스티","다인","티셔","백작","보초병","우트","랜스","뮤즈","리즈","브라키의여전사","에스피","코니","스투","라니체","드류","체드","체스터","케인","울드","티모시","포츠","마카","미카","경비병","니키","수라","카르고","엘피","쿠퍼","페니","터크","나크레토","로비어","앤타이","셀포이","비바","마데이아","가토고","엑소포","토이슨","코메이오","저주받은엘프","야노모이","오이피노","카레푸","엠토포","아이보","마나오","클레오","파노아","타키아","카오네자","나노아","미노스","세니코","주사위소녀1","주사위소녀1","주사위소녀2","주사위소녀3","주사위소녀4","주사위소녀5","주사위소녀6","주사위소녀7","주사위소녀8","주사위소녀9","주사위소녀10","주사위","주사위지배인","리노스","투페","히포프","베스","쿠키","소피","포프리아","나무꾼","레아","키아","세르니오","코르티","베커","포비","크로리스","길잃은수색대","동쪽파수꾼","서쪽파수꾼","리노아","펫조련사","게시판","드골"]
로랜시아간판 := [111,608,610,612,614,618,620,622,624,626,630,632,634,636,638,640,642,644,646,648,650]
이름이바뀌는존재들 := [21,751,753,552,554,560,558,556,496] ;혹은 애완동물

오란의깃마을_DDLOptions := ["로랜시아","에필로리아","세르니카","크로노시스","포프레스네"]
길탐색5번목적지_DDLOptions := 길탐색4번목적지_DDLOptions := 길탐색3번목적지_DDLOptions := 길탐색2번목적지_DDLOptions := 길탐색1번목적지_DDLOptions := ["로랜시아 목공소","로랜시아 퍼브","로랜시아 우체국","로랜시아 퍼브 우체국","에필로리아 목공소","에필로리아 퍼브","에필로리아 우체국","에필로리아 퍼브 우체국","세르니카 퍼브","세르니카 우체국","세르니카 목공소","포프레스네 무기상점"]
CurrentMode_DDLOptions := ["대기모드","자동감응","일반자사","포남자사","포북자사","나프마통작","마잠또는밥통","광물캐기","배달하기","행깃교환","행깃구매","리스무기구매"]
메인캐릭터서버_DDLOptions := ["엘","테스"]
메인캐릭터순서_DDLOptions := [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20]
힐링포션사용단축키_DDLOptions := [3,4,5,6,7,8]
마나포션사용단축키_DDLOptions := [3,4,5,6,7,8]
식빵사용단축키_DDLOptions := [8,9]
오란의깃사용단축키_DDLOptions := [3,4,5,6,7,8]
길탐색책단축키_DDLOptions := [3,4,5,6,7,8]
오란의깃단축키_DDLOptions := [3,4,5,6,7,8]
링단축키_DDLOptions := [3,4,5,6,7,8]
포레스트네자동대화딜레이_DDLOptions := ["10분","1분","5분","19분","29분"]
식빵구매마을_DDLOptions := ["로랜시아","에필로리아","세르니카","크로노시스","포프레스네"]
핵심지침서_DDLOptions := ["목공지침서 1-1 소나무 가공(Lv1)", "목공지침서 1-2 단풍나무 가공(Lv1)", "목공지침서 1-3 참나무 가공(Lv1)","세공지침서 1-1 기초 세공(Lv1)","세공지침서 2-4 브라키디온 가공(Lv2)","세공지침서 3-4 알티브라키디온 가공(Lv3)","세공지침서 4-4 브라키시온(원석) 가공(Lv4)","세공지침서 5-4 브라키시온 가공(Lv5)","세공지침서 6-1 아이언링 제작1(Lv6)","세공지침서 7-1 아이언네클리스 제작1(Lv7)","세공지침서 8-3 케이온 제작(Lv8)","세공지침서 9-1 초급 가공1(Lv9)", "세공지침서 10-1 중급 가공1(Lv10)"]
지침서_DDLOptions := ["요리지침서 1-1 달걀 요리(Lv1)", "요리지침서 1-2 식빵 요리(Lv1)", "요리지침서 1-3 스프 요리(Lv1)", "요리지침서 1-4 샌드위치 요리(Lv1)", "요리지침서 1-5 초컬릿(Lv1)", "요리지침서 1-6 송편(Lv1)", "요리지침서 2-1 주먹밥 요리(Lv2)", "요리지침서 2-2 오믈렛 요리(Lv2)", "요리지침서 2-3 파이 요리(Lv2)", "요리지침서 2-4 케익 요리(Lv2)", "요리지침서 2-5 쥬스 요리(Lv2)", "요리지침서 3-1 카레 요리(Lv3)", "요리지침서 3-2 마늘 요리(Lv3)", "요리지침서 4-1 비스킷 요리(Lv4)", "요리지침서 4-2 닭고기 요리(Lv4)", "요리지침서 4-3 돼지고기 요리(Lv4)", "요리지침서 4-4 생선 요리(Lv4)", "요리지침서 4-5 초밥 요리(Lv4)", "요리지침서 5-1 팥빙수 요리(Lv5)", "요리지침서 5-2 스파게티 요리(Lv5)", "요리지침서 5-3 김치 요리(Lv5)", "요리지침서 5-4 볶음밥 요리(Lv5)", "스미스지침서 1-1 툴 수리(Lv1)", "스미스지침서 1-2 검 수리(Lv1)", "스미스지침서 1-3 창 수리(Lv1)", "스미스지침서 1-4 기타 수리(Lv1)", "스미스지침서 2-1 낚시대 제작(Lv2)", "스미스지침서 2-2 픽액스 제작(Lv2)", "스미스지침서 2-3 요리키트 제작(Lv2)", "스미스지침서 2-4 미리온스캐너 제작(Lv2)", "스미스지침서 2-5 스미스키트 제작(Lv2)", "스미스지침서 2-6 재단키트 제작(Lv2)", "스미스지침서 2-7 세공키트 제작(Lv2)", "스미스지침서 2-8 관측키트 제작(Lv2)", "스미스지침서 3-1 롱소드 제작(Lv3)", "스미스지침서 3-2 바스타드소드 제작(Lv3)", "스미스지침서 3-3 그레이트소드 제작(Lv3)", "스미스지침서 3-4 대거 제작(Lv3)", "스미스지침서 3-5 고태도 제작(Lv3)", "스미스지침서 3-6 롱스피어 제작(Lv3)", "스미스지침서 3-7 반월도 제작(Lv3)", "스미스지침서 3-8 액스 제작(Lv3)", "스미스지침서 3-9 햄머 제작(Lv3)", "스미스지침서 3-10 우든보우 제작(Lv3)", "스미스지침서 3-11 우든하프 제작(Lv3)", "스미스지침서 3-12 시미터 제작(Lv3)", "스미스지침서 4-1 아이언아머 제작(Lv4)", "스미스지침서 4-2 폴드아머 제작(Lv4)", "스미스지침서 4-3 스탠다드 아머 제작(Lv4)", "스미스지침서 4-4 터틀아머 제작(Lv4)", "스미스지침서 4-5 트로져아머 제작(Lv4)", "스미스지침서 4-6 숄드레더 아머 제작(Lv4)", "스미스지침서 4-7 밴디드레더 아머 제작(Lv4)", "스미스지침서 4-8 밴디드아이언 아머 제작(Lv4)", "스미스지침서 4-9 밴디드실버 아머 제작(Lv4)", "스미스지침서 4-10 밴디드골드 아머 제작(Lv4)", "스미스지침서 5-1 우든실드 제작(Lv5)", "스미스지침서 5-2 실드 제작(Lv5)", "스미스지침서 5-3 아이언실드 제작(Lv5)", "스미스지침서 5-4 스톤실드 제작(Lv5)", "스미스지침서 5-5 골든실드 제작(Lv5)", "스미스지침서 6-1 올드헬멧 제작(Lv6)", "재단지침서 1-1 반바지 수선(Lv1)", "재단지침서 1-2 바지 수선(Lv1)", "재단지침서 1-3 튜닉 수선(Lv1)", "재단지침서 1-4 가니쉬 수선(Lv1)", "재단지침서 1-5 레더슈즈 수선(Lv1)", "재단지침서 1-6 레더아머 수선(Lv1)", "재단지침서 2-1 반바지 제작(Lv2)", "재단지침서 2-2 바지 제작(Lv2)", "재단지침서 2-3 튜닉 제작(Lv2)", "재단지침서 2-4 가니쉬 제작(Lv2)", "재단지침서 2-5 레더슈즈 제작(Lv2)", "재단지침서 2-6 레더아머 제작(Lv2)", "재단지침서 2-7 수영모 제작(Lv2)", "재단지침서 2-8 꽃무늬수영모 제작(Lv2)", "재단지침서 3-1 울슈즈 제작(Lv3)", "재단지침서 3-2 밤슈즈 제작(Lv3)", "재단지침서 4-1 밧줄 제작(Lv4)", "재단지침서 4-2 꽃무늬반바지 제작(Lv4)", "재단지침서 4-3 꽃무늬바지 제작(Lv4)", "재단지침서 4-4 꽃무늬치마 제작(Lv4)", "재단지침서 4-5 줄무늬바지 제작(Lv4)", "재단지침서 4-6 나팔바지 제작(Lv4)", "재단지침서 4-7 칠부바지 제작(Lv4)", "재단지침서 4-8 꽃무늬튜닉 제작(Lv4)", "재단지침서 4-9 줄무늬튜닉 제작(Lv4)", "재단지침서 4-10 터번 제작(Lv4)", "재단지침서 4-11 볼륨업브라 제작(Lv4)", "재단지침서 4-12 탑 제작(Lv4)", "재단지침서 4-13 미니스커트 제작(Lv4)", "재단지침서 4-14 햅번민소매 제작(Lv4)", "재단지침서 4-15 햅번긴소매 제작(Lv4)", "재단지침서 4-16 땡땡브라 제작(Lv4)", "재단지침서 4-17 니혼모자 제작(Lv4)", "재단지침서 5-1 튜닉 제작2(Lv5)", "재단지침서 5-2 반바지 제작2(Lv5)", "재단지침서 5-3 바지 제작2(Lv5)", "재단지침서 5-4 가니쉬 제작2(Lv5)", "재단지침서 5-5 레더아머 제작2(Lv5)", "재단지침서 5-6 레더슈즈 제작2(Lv5)", "재단지침서 5-7 울슈즈 제작2(Lv5)", "재단지침서 5-8 밤슈즈 제작2(Lv5)", "재단지침서 5-9 수영모 제작2(Lv5)", "재단지침서 5-10 꽃무늬수영모 제작2(Lv5)", "세공지침서 1-1 기초 세공(Lv1)", "세공지침서 1-2 링 수리(Lv1)", "세공지침서 1-3 네클리스 수리(Lv1)", "세공지침서 2-1 브리디온 가공(Lv2)", "세공지침서 2-2 다니온 가공(Lv2)", "세공지침서 2-3 마하디온 가공(Lv2)", "세공지침서 2-4 브라키디온 가공(Lv2)", "세공지침서 2-5 브라키디온 가공(Lv2)", "세공지침서 2-6 테사랏티온 가공(Lv2)", "세공지침서 3-1 알티브리디온 가공(Lv3)", "세공지침서 3-2 알티다니온 가공(Lv3)", "세공지침서 3-3 알티마하디온 가공(Lv3)", "세공지침서 3-4 알티브라키디온 가공(Lv3)", "세공지침서 3-5 볼바디온 가공(Lv3)", "세공지침서 3-6 테사리온 가공(Lv3)", "세공지침서 4-1 브리시온(원석) 가공(Lv4)", "세공지침서 4-2 다니시온(원석) 가공(Lv4)", "세공지침서 4-3 마흐시온(원석) 가공(Lv4)", "세공지침서 4-4 브라키시온(원석) 가공(Lv4)", "세공지침서 4-5 엘리시온(원석) 가공(Lv4)", "세공지침서 4-6 테스시온(원석) 가공(Lv4)", "세공지침서 5-1 브리시온 가공(Lv5)", "세공지침서 5-2 다니시온 가공(Lv5)", "세공지침서 5-3 마흐시온 가공(Lv5)", "세공지침서 5-4 브라키시온 가공(Lv5)", "세공지침서 5-5 엘리시온 가공(Lv5)", "세공지침서 5-6 테스시온 가공(Lv5)", "세공지침서 6-1 아이언링 제작1(Lv6)", "세공지침서 6-2 실버링 제작1(Lv6)", "세공지침서 6-3 골드링 제작1(Lv6)", "세공지침서 6-4 에메랄드링 제작1(Lv6)", "세공지침서 6-5 사파이어링 제작1(Lv6)", "세공지침서 6-6 투어마린링 제작1(Lv6)", "세공지침서 6-7 브리디온링 제작1(Lv6)", "세공지침서 6-8 다니온링 제작1(Lv6)", "세공지침서 6-9 마하디온링 제작1(Lv6)", "세공지침서 6-10 브라키디온링 제작1(Lv6)", "세공지침서 6-11 엘사리온링 제작1(Lv6)", "세공지침서 6-12 테사리온링 제작1(Lv6)", "세공지침서 7-1 아이언네클리스 제작1(Lv7)", "세공지침서 7-2 실버네클리스 제작1(Lv7)", "세공지침서 7-3 골드네클리스 제작1(Lv7)", "세공지침서 7-4 루비네클리스 제작1(Lv7)", "세공지침서 7-5 상아네클리스 제작1(Lv7)", "세공지침서 7-6 사파이어네클리스 제작1(Lv7)", "세공지침서 7-7 펄네클리스 제작1(Lv7)", "세공지침서 7-8 블랙펄네클리스 제작1(Lv7)", "세공지침서 7-9 오레온 제작(Lv7)", "세공지침서 7-10 세레온 제작(Lv7)", "세공지침서 8-1 기초 가공1(Lv8)", "세공지침서 8-2 기초 가공2(Lv8)", "세공지침서 8-3 케이온 제작(Lv8)", "세공지침서 9-1 초급 가공1(Lv9)", "세공지침서 10-1 중급 가공1(Lv10)", "세공지침서 11-1 고급 가공1(Lv11)", "미용지침서 1-1 기초 염색(Lv1)", "미용지침서 2-1 삭발 스타일(Lv2)", "미용지침서 2-2 기본 스타일(Lv2)", "미용지침서 2-3 펑크 스타일(Lv2)", "미용지침서 2-4 레게 스타일(Lv2)", "미용지침서 2-5 변형 스타일(Lv2)", "미용지침서 2-6 더벅 스타일(Lv2)", "미용지침서 2-7 바람 스타일(Lv2)", "미용지침서 2-8 복고 스타일(Lv2)", "미용지침서 2-9 자연 스타일(Lv2)", "미용지침서 2-10 웨이브 스타일(Lv2)", "미용지침서 2-11 세팅 스타일(Lv2)", "미용지침서 2-12 폭탄 스타일(Lv2)", "미용지침서 2-13 야자수 스타일(Lv2)", "미용지침서 2-14 발랄 스타일(Lv2)", "미용지침서 2-15 변형레게 스타일(Lv2)", "미용지침서 2-16 올림 스타일(Lv2)", "미용지침서 2-17 곱슬 스타일(Lv2)", "미용지침서 2-18 미남스타일 변형(Lv2)", "미용지침서 2-19 바가지 스타일(Lv2)", "미용지침서 2-20 선녀 스타일(Lv2)", "미용지침서 2-21 밤톨 스타일(Lv2)", "미용지침서 2-22 귀족 스타일(Lv2)", "미용지침서 2-23 드라마 스타일(Lv2)", "미용지침서 2-24 앙증 스타일(Lv2)", "미용지침서 2-25 트윈테일 스타일(Lv2)", "미용지침서 3-1 검은눈 성형(Lv3)", "미용지침서 3-2 파란눈 성형(Lv3)", "미용지침서 3-3 찢어진눈 성형(Lv3)", "목공지침서 1-1 소나무 가공(Lv1)", "목공지침서 1-2 단풍나무 가공(Lv1)", "목공지침서 1-3 참나무 가공(Lv1)", "목공지침서 1-4 대나무 가공(Lv1)", "목공지침서 2-1 토끼조각상 조각(Lv2)", "목공지침서 2-2 암탉조각상 조각(Lv2)", "목공지침서 2-3 수탉조각상 조각(Lv2)", "목공지침서 2-4 푸푸조각상 조각(Lv2)", "목공지침서 3-1 토끼상자 조각(Lv3)", "목공지침서 3-2 푸푸상자 조각(Lv3)", "목공지침서 3-3 오크상자 조각(Lv3)", "목공지침서 3-4 고블린상자 조각(Lv3)", "목공지침서 4-1 뗏목 제작(Lv4)", "목공지침서 4-2 나무보트 제작(Lv4)", "목공지침서 5-1 스노우보드 제작(Lv5)", "목공지침서 5-2 썰매 제작(Lv5)", "연금술지침서 1-1 힐링포션 제작(Lv1)", "연금술지침서 1-2 마나포션 제작(Lv1)", "연금술지침서 1-3 단검용독 제작(Lv1)", "연금술지침서 2-1 스피드포션(1ml) 제작(Lv2)", "연금술지침서 2-2 스피드포션(2ml) 제작(Lv2)", "연금술지침서 2-3 스피드포션(3ml) 제작(Lv2)", "연금술지침서 2-4 스피드포션(4ml) 제작(Lv2)", "연금술지침서 2-5 스피드포션(5ml) 제작(Lv2)", "연금술지침서 2-6 스피드포션(6ml) 제작(Lv2)", "연금술지침서 2-7 체력향상포션(1ml) 제작(Lv2)", "연금술지침서 2-8 체력향상포션(2ml) 제작(Lv2)", "연금술지침서 2-9 체력향상포션(3ml) 제작(Lv2)", "연금술지침서 2-10 체력향상포션(4ml) 제작(Lv2)", "연금술지침서 2-11 체력향상포션(5ml) 제작(Lv2)", "연금술지침서 2-12 체력향상포션(6ml) 제작(Lv2)", "연금술지침서 3-1 주괴 제작(Lv3)"]

Global 나가기가능맵 := [229,1229,2229,3229,4229,208,214,217,219,1208,1214,1217,1219,2208,2214,2217,2219,4200,4207,4209,4211,4213,4215,4216,4219]

Global CurrentMode
Global 서버상태

;자동사냥용
Global 몬스터소탕 := {}
Global 무바여부 := 0
Global 무기수리필요여부확인 := 0
Global STOPSIGN := false
Global 무기수리필요 := false
Global 라깃구매필요 := false
Global 식빵구매필요 := false
Global 그레이드필요 := false
Global 골드바판매필요 := false
Global 골드바구매필요 := false
Global NPC대화창사용중 := false
Global 거래창사용중 := false
Global 영번어빌 := 0
Global 일번어빌 := 0
Global 이번어빌 := 0
Global 삼번어빌 := 0
Global 영번어빌카운트 := 0
Global 일번어빌카운트 := 0
Global 이번어빌카운트 := 0
Global 삼번어빌카운트 := 0
Global abilities := {}
Global countCheck := {}
Global abilityCheck := {}
Global abilityStates := []
Global RecentWeapons := []
Global 그레이드종류
Global 그레이드할어빌
Global GALRID
;메모리검색용
Global WantedItemlength := 0
Global WantedMonsters := []
Global DisWantedMonsters := []
Global WantedItems := []
Global BlackList := []
Global MonsterList := []
Global itemList := []
Global PlayerList := []

;배달용
Global 현재마을 := ""
GLobal 목적마을 := ""
Global 목적지 := ""

;아이템 갯수 확인용
Global 아이템갯수 := {}

;스핵용
Global MoveSpeed
Global 게임배속

;기본정보용
Global 기존맵번호 := 0
Global 맵이름
Global 맵번호
Global 차원
Global 좌표X
Global 좌표Y
Global 좌표Z
Global 현재HP
Global 최대HP
Global 현재MP
Global 최대MP
Global 현재FP
Global 최대FP

;타이머들
Global StartTime := A_TickCount
Global 소지아이템리스트업데이트딜레이 := A_TickCount
Global RunThreadCounter := A_TickCount
Global PT_Delays := A_TickCount
Global NSK_Counts := A_TickCount
Global NPC_TALK_DELAYCOUNT := A_TickCount
Global Read_Memory_Count := A_TickCount

;윈도우 배율
Global Multiplyer := "없음" ;Windows7 800x600 기준 = 1
Global NPC_MSG_ADR := "없음"

Global 상승어빌주소

;일랜시아 프로그램 감시용
Global mem
Global ElanTitles
Global TargetPid
Global TargetTitle := ""
ReadAllElanciaTitle()
return
;}
;}

;-------------------------------------------------------
;-------외부 함수----------------------------------------
;-------------------------------------------------------
;{

DownloadOID()
{
	URL := "https://script.google.com/macros/s/AKfycbyNkIdaVCOw9nf7bvHwqdzAFKPALYzgWy-Ukyro-ZBQriDCo7T12CSx6GWvNC6m93cTcQ/exec"

	WebRequest := ComObjCreate("WinHttp.WinHttpRequest.5.1")

	WebRequest.Open("GET", URL)

	WebRequest.Send()

	WebRequest.WaitForResponse()

	response := {}

	response := WebRequest.ResponseText

	jsonResponse := RegExReplace(response, ".*?""value"":""(.*?)"".*", "$1")

	StringSplit, valuesArray, jsonResponse, `,

	길잃은수색대알파OID := valuesArray1
	길잃은수색대베타OID := valuesArray2
	길잃은수색대감마OID := valuesArray3
	동쪽파수꾼알파OID := valuesArray4
	동쪽파수꾼베타OID := valuesArray5
	동쪽파수꾼감마OID := valuesArray6
	서쪽파수꾼알파OID := valuesArray7
	서쪽파수꾼베타OID := valuesArray8
	서쪽파수꾼감마OID := valuesArray9
	if (길잃은수색대알파OID != 0)
		Downloaded_OID_RECORD("NPC리스트", "NPC", "알파", " 포프레스네 북쪽 필드", 4003, "길잃은수색대", 길잃은수색대알파OID, 188, 112, 1, 0, 0, 462)
	if (길잃은수색대베타OID != 0)
		Downloaded_OID_RECORD("NPC리스트", "NPC", "베타", " 포프레스네 북쪽 필드", 4003, "길잃은수색대", 길잃은수색대베타OID, 188, 112, 1, 0, 0, 462)
	if (길잃은수색대감마OID != 0)
		Downloaded_OID_RECORD("NPC리스트", "NPC", "감마", " 포프레스네 북쪽 필드", 4003, "길잃은수색대", 길잃은수색대감마OID, 188, 112, 1, 0, 0, 462)
	if (서쪽파수꾼알파OID != 0)
		Downloaded_OID_RECORD("NPC리스트", "NPC", "알파", " 포프레스네 남쪽 필드", 4005, "서쪽파수꾼", 서쪽파수꾼알파OID, 188, 112, 1, 0, 0, 462)
	if (서쪽파수꾼베타OID != 0)
		Downloaded_OID_RECORD("NPC리스트", "NPC", "베타", " 포프레스네 남쪽 필드", 4005, "서쪽파수꾼", 서쪽파수꾼베타OID, 188, 112, 1, 0, 0, 462)
	if (서쪽파수꾼감마OID != 0)
		Downloaded_OID_RECORD("NPC리스트", "NPC", "감마", " 포프레스네 남쪽 필드", 4005, "서쪽파수꾼", 서쪽파수꾼감마OID, 188, 112, 1, 0, 0, 462)
	if (동쪽파수꾼알파OID != 0)
		Downloaded_OID_RECORD("NPC리스트", "NPC", "알파", " 포프레스네 남쪽 필드", 4005, "동쪽파수꾼", 동쪽파수꾼알파OID, 192, 34, 1, 0, 0, 462)
	if (동쪽파수꾼베타OID != 0)
		Downloaded_OID_RECORD("NPC리스트", "NPC", "베타", " 포프레스네 남쪽 필드", 4005, "동쪽파수꾼", 동쪽파수꾼베타OID, 192, 34, 1, 0, 0, 462)
	if (동쪽파수꾼감마OID != 0)
		Downloaded_OID_RECORD("NPC리스트", "NPC", "감마", " 포프레스네 남쪽 필드", 4005, "동쪽파수꾼", 동쪽파수꾼감마OID, 192, 34, 1, 0, 0, 462)
}

uJoin(URL)
{
	return
	;return
	URL := URLEncode(URL)
	guicontrol,,url,%URL%
	try
	{
		HttpObj := ComObjCreate("WinHttp.WinHttpRequest.5.1")
	}
	catch e
	{
		uJoin(URL)
	}
;	HttpObjPtr:=&HttpObj

	HttpObj.Open("GET",URL)
	HttpObj.Send()

	;HttpObj.WaitForResponse
	;~ ResponsedText:=HttpObj.Responsetext()
	;HttpObj:=""
}

URLEncode(str, sExcepts = "!#$&'()*+,-./:;=?@_~")
{
    len := StrPutVar(str, var, "UTF-8") - 1
    result := ""
    i := 0
    oldFmt := A_FormatInteger
    SetFormat, Integer, hex
    While (i < len) {
        b := NumGet(var, i, "UChar")
        If (b >= 0x41 && b <= 0x5A ; A-Z
            || b >= 0x61 && b <= 0x7A ; a-z
            || b >= 0x30 && b <= 0x39 ; 0-9
            || InStr(sExcepts, Chr(b), true))
            result .= Chr(b)
        Else {
            hex := SubStr(StrUpper(b), 3)
            If (StrLen(hex) == 1)
                hex := "0" . hex
            result .= "%" . hex
        }
        i++
    }
    SetFormat, Integer, %oldFmt%
    return result
}

StrPutVar(str, ByRef var, encoding)
{
    VarSetCapacity(var, StrPut(str, encoding) * ((encoding == "utf-16" || encoding == "cp1200") ? 2 : 1))
    return StrPut(str, &var, encoding)
}

StrUpper(str)
{
    StringUpper, out, str
    return out
}

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
WinGet, pid, pid, ahk_pid %PID%
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
WinGet, hWnd, ID, ahk_pid %PID%
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

;}

;-------------------------------------------------------
;-------제작 함수----------------------------------------
;-------------------------------------------------------
;{
	;{ 미분류

	미니맵클릭하여좌표이동(input_x,input_y)
	{
		미니맵x := mem.read(0x0058EB48, "UInt", 0x80)
		미니맵y := mem.read(0x0058EB48, "UInt", 0x84)
		gosub, 기본정보읽기
		gui,submit,nohide
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
		MouseClick(output_x, output_y)
	}

	Mapreopen()
	{
		Gui,Submit,Nohide
		PID := TargetPid
		if(UiTest(1) = 0 )
		{
			PostMessage, 0x100, 0xA4, 0,,ahk_pid %PID%
			PostMessage, 0x100, 0x56, 3080193,,ahk_pid %PID%
			PostMessage, 0x101, 0xA4, 0,,ahk_pid %PID%
			MapBig := mem.read(0x0058DAD0, "UInt", 0xC, 0x10, 0x8, 0x264)
			gosub, 기본정보읽기
			gui,submit,nohide
			if( 맵번호 = 237 && MapBig!=1)
			{
				sleep, 100
				MouseClick(725, 484)
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

	Search_Book(Num)
	{
		if !(위치고정 = 1)
		{
			CheatEngine_DoNotMove()
		}
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
		MouseClick(MoveX,MoveY)
		else if(Num = 1)
		{
			MouseClick(X1,Y1)
			sleep,100
			MouseClick(MoveX,MoveY)
		}
		else if(Num =2)
		{
			MouseClick(X1,Y2)
			sleep,100
			MouseClick(MoveX,MoveY)
		}
		else if(Num =3)
		{
			MouseClick(X1,Y3)
			sleep,100
			MouseClick(MoveX,MoveY)
		}
		else if(Num =4)
		{
			MouseClick(X1,Y4)
			sleep,100
			MouseClick(MoveX,MoveY)
		}
		else if(Num =5)
		{
			MouseClick(X1,Y5)
			sleep,100
			MouseClick(MoveX,MoveY)
		}
		sleep, 300
		if (위치고정 != 1)
		{
			CheatEngine_CancelDoNotMove()
		}
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
			MouseClick(MoveX,MoveY)
		else if(Num = 1)
		{
			MouseClick(X1,Y1)
			sleep,100
			MouseClick(MoveX,MoveY)
		}
		else if(Num =2)
		{
			MouseClick(X1,Y2)
			sleep,100
			MouseClick(MoveX,MoveY)
		}
		else if(Num =3)
		{
			MouseClick(X1,Y3)
			sleep,100
			MouseClick(MoveX,MoveY)
		}
		else if(Num =4)
		{
			MouseClick(X1,Y4)
			sleep,100
			MouseClick(MoveX,MoveY)
		}
		else if(Num =5)
		{
			MouseClick(X1,Y5)
			sleep,100
			MouseClick(MoveX,MoveY)
		}
	}

	CallNPC(호출할NPC)
	{
		sleep,1000
		gosub, 기본정보읽기
		gui,submit,nohide
		/*
		비교번호 := 0
		if (호출할NPC = "성검사")
		{
		비교번호 := 269
		}
		else if (호출할NPC = "드골")
		{
		비교번호 := 4209
		}
		else if (호출할NPC = "리노아")
		{
		비교번호 := 4002
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
		*/
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
				WriteExecutableMemory("NPC호출용1")
				WriteExecutableMemory("NPC호출용2")
				mem.write(0x00527b54, NPCOID, "UInt", aOffset*)
				sleep, 1000
				RunMemory("NPC호출")
				SB_SETTEXT(호출할NPC "(" NPCOID ") 호출" , "2")
				settimer, IsNPCOIDCorret, -3000
				Return 1
			}
			else
				Return 0
			sleep, 300
		;}
		Return 0
	}

	CallSoya(호출할NPC)
	{
		sleep,1000
		gosub, 기본정보읽기
		gui,submit,nohide
		NPCOID := ""
		gui,listview,고용상인리스트
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
			WriteExecutableMemory("NPC호출용1")
			WriteExecutableMemory("NPC호출용2")
			mem.write(0x00527b54, NPCOID, "UInt", aOffset*)
			sleep, 1000
			RunMemory("NPC호출")
			SB_SETTEXT(호출할NPC "(" NPCOID ") 호출" , "2")
			Return 1
		}
		else
			Return 0
		sleep, 300
		;}
		Return 0
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
			MouseClick(x,y)
			sleep,100
		}
	}

	NPCMENUCLICK(what,key)
	{
		ErrorLevel_check := 0
		loop,
		{
			NPCMenu := mem.read(0x0058F0A4, "UInt", aOffsets*)
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
			MouseClick(x,y)
			sleep,100
		}
	}

	라깃사용하기(마을,목적차원)
	{
		if (아이템갯수["라스의깃"] < 1)
		{
			SB_SetText("라스의깃 소지 여부 확인필요", 2)
			return
		}
		라스의깃단축키 := 0

		KeyClick(라스의깃단축키)

		Dimension := mem.read(0x0058EB1C, "UInt", 0x10A)
		if(Dimension>20000)
			Dim1:=1
		else if(Dimension>10000)
			Dim1:=1
		else if(Dimension<10000)
			Dim1:=2

		if (목적차원 = "베타" || 목적차원 = "감마")
			Dim2 := 1
		else
			Dim2 := 2

		if (Dim1 != Dim2)
			StopSign := True

		loop, 10
		{
			sleep,1
			if (라스의깃열려있는지확인() != 0)
				break
		}
		sleep,1
		라스의깃마을선택(마을)
		sleep,1
		loop, 10
		{
			sleep,1
			if (라스의깃마을선택됬는지확인() != 0)
				break
		}
		라스의깃차원선택(마을,목적차원)
		return
	}

	라스의깃열려있는지확인() ; 0 닫힘 ; != 0 열림
	{
	result := mem.read(0x0058F0CC, "UInt", aOffsets*)
	return result
	}

	라스의깃마을선택됬는지확인() ; 0 안됨 ; != 0 됨
	{
	result := mem.read(0x0058F100, "UInt", aOffsets*)
	return result
	}

	라스의깃마을선택(마을)
	{
		If (마을 = "로랜시아")
		{
			MouseClick(270,370)
		}
		else If (마을 = "에필로리아")
		{
			MouseClick(275,205)
		}
		else If (마을 = "세르니카")
		{
			MouseClick(545,140)
		}
		else If (마을 = "크로노시스")
		{
			MouseClick(430,405)
		}
		else If (마을 = "포프레스네")
		{
			MouseClick(630,365)
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
			MouseClick(차원X,347)
		}
		else If (마을 = "에필로리아")
		{
			MouseClick(차원X,187)
		}
		else If (마을 = "세르니카")
		{
			MouseClick(차원X,120)
		}
		else If (마을 = "크로노시스")
		{
			MouseClick(차원X,384)
		}
		else If (마을 = "포프레스네")
		{
			MouseClick(차원X,345)
		}
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

	get_NPCTalk_cordi()
	{
		x := mem.read(0x0058EB48, "UInt", 0xC8)
		y := mem.read(0x0058EB48, "UInt", 0xCC)
		Result := {"x":x, "y":y}
		Return Result
	}

	NPC거래창전체수리클릭()
	{
	tempx := mem.read(0x0058EB48, "UInt",0x8C) + 423 - 293
	tempy := mem.read(0x0058EB48, "UInt",0x90) + 322 - 173
	MouseClick(tempx,tempy)
	}

	NPC거래창OK클릭()
	{
	tempx := mem.read(0x0058EB48, "UInt",0x8C) + 423 - 233
	tempy := mem.read(0x0058EB48, "UInt",0x90) + 322 - 173
	MouseClick(tempx,tempy)
	}

	NPC거래창닫기()
	{
	tempx := mem.read(0x0058EB48, "UInt",0x8C) + 205 - 233
	tempy := mem.read(0x0058EB48, "UInt",0x90) + 57 - 173
	MouseClickRightButton(tempx,tempy)
	}

	NPC거래창첫번째메뉴클릭()
	{
		tempx := mem.read(0x0058EB48, "UInt",0x8C) + 205 - 233
		tempy := mem.read(0x0058EB48, "UInt",0x90) + 57 - 173
		MouseClick(tempx,tempy)
	}

	;}

	;{ ; 좀비몹 혹은 렉으로 인한 헛공격 확인
		TrackWeaponChange(newWeapon)
		{
			global RecentWeapons
			; 무기가 이미 배열에 있는지 확인
			for index, weapon in RecentWeapons
			{
				if (weapon == newWeapon)
				{
					; 동일한 무기가 이미 있으면, 여기서 함수 종료
					return
				}
			}
			; 새로운 무기를 배열의 시작 부분에 추가
			RecentWeapons.InsertAt(1, newWeapon)
			; 배열이 3개 이상의 항목을 가지고 있다면, 가장 오래된 항목(4번째)을 제거
			if (RecentWeapons.MaxIndex() > 3)
			{
				RecentWeapons.RemoveAt(4)
			}
		}

		CheckTrackedWeapons() {
			global RecentWeapons
			; 배열에 저장된 Weapon의 개수를 반환
			return RecentWeapons.MaxIndex()
		}

		UpdateAbility(abilityName, abilityValue, abilityCount, RequiredAbilityCount)
		{
			oldValue := abilityCheck.HasKey(abilityName) ? abilityCheck[abilityName] : 0
			oldCount := countCheck.HasKey(abilityName) ? countCheck[abilityName] : 0
			if (abilityValue = 10000)
				gosub, 어빌리티읽어오기
			else if (abilityValue = 100)
				gosub, 마법읽어오기
			abilityCheck[abilityName] := abilityValue
			countCheck[abilityName] := abilityCount

			; 첫 입력 감지를 위한 변수
			isFirstInput := (oldValue = 0 and oldCount = 0)

			; 올른카운트 계산
			raisedCount := 0

			if (!isFirstInput) {
				raisedCount := abilityCount - oldCount + RequiredAbilityCount * (abilityValue - oldValue)
			}

			; 변화가 있는지 확인 및 메시지 출력
			if (raisedCount > 0)
			{
				sb_settext(abilityName "(" Round(abilityValue / 100,2) " - " abilityCount "/" RequiredAbilityCount ") " raisedCount "카운트 상승"  ,2)
				UpdateAbilityState(abilityName,raisedCount)
			}
			return raisedCount
		}

		IsBalancedGrowth(minAbilities := 1)
		{
			balanced := 0
			for _, state in abilityStates {
				if (state.IncreaseAmount > 0) {
					balanced += 1
				}
				if (balanced >= minAbilities) {
					return true
				}
			}
			return false
		}

		UpdateAbilityState(abilityName, increaseAmount)
		{
			; 기존 어빌 상태 찾기 또는 새로운 어빌 상태 추가
			found := false
			for index, state in abilityStates {
				if (state.Name = abilityName) {
					state.CurrentValue += increaseAmount
					state.IncreaseAmount += increaseAmount
					found := true
					break
				}
			}
			if (!found) {
				newAbility := {Name: abilityName, CurrentValue: increaseAmount, IncreaseAmount: increaseAmount}
				abilityStates.Push(newAbility)
			}
		}

		UpdateGUI(index, raisedCount)
		{
			abilities[index].Count += raisedCount
			Name := abilities[index].Name
			guicontrol,, abilityName%index%, %Name%
			Count := abilities[index].Count
			guicontrol,, abilityCount%index%, %Count%
		}

	;}

	;{ ; 마우스 및 키입력 제어 함수
		KeyClick(Key) ; 게임내 KeyBorad 키 보내기
		{
			PID := TargetPID
			;sb_settext(TargetPID "," key ,2)
			if(Key = "Enter"){
			loop, 1 {
			PostMessage, 0x100, 13, 1835009,, ahk_pid %PID% ; Enter Lock
			PostMessage, 0x101, 13, 1835009,, ahk_pid %PID% ; Enter Release
			sleep, 1
			}
			}
			else if(Key = "Shift"){
			loop, 1 {
			PostMessage, 0x100, 16, 2752513,, ahk_pid %PID% ; Shift Lock
			PostMessage, 0x101, 16, 2752513,, ahk_pid %PID% ; Shift Release
			sleep, 1
			}
			}
			else if(Key = "ㄱ"){
			loop, 1 {
			PostMessage, 0x100, 229, 1245185,, ahk_pid %PID%
			PostMessage, 0x101, 229, 1245185,, ahk_pid %PID%
			sleep, 1
			}
			}
			else if(Key = "a"){
			loop, 1 {
			PostMessage, 0x100, 65, 1966081,, ahk_pid %PID%
			PostMessage, 0x101, 65, 1966081,, ahk_pid %PID%
			sleep, 1
			}
			}
			else if(Key = "b"){
			loop, 1 {
			PostMessage, 0x100, 66, 3145729,, ahk_pid %PID%
			PostMessage, 0x101, 66, 3145729,, ahk_pid %PID%
			sleep, 1
			}
			}
			else if(Key = "c"){
			loop, 1 {
			PostMessage, 0x100, 67, 3014657,, ahk_pid %PID%
			PostMessage, 0x101, 67, 3014657,, ahk_pid %PID%
			sleep, 1
			}
			}
			else if(Key = "d"){
			loop, 1 {
			PostMessage, 0x100, 68, 2097153,, ahk_pid %PID%
			PostMessage, 0x101, 68, 2097153,, ahk_pid %PID%
			sleep, 1
			}
			}
			else if(Key = "e"){
			loop, 1 {
			PostMessage, 0x100, 69, 1179649,, ahk_pid %PID%
			PostMessage, 0x101, 69, 1179649,, ahk_pid %PID%
			sleep, 1
			}
			}
			else if(Key = "f"){
			loop, 1 {
			PostMessage, 0x100, 70, 2162689,, ahk_pid %PID%
			PostMessage, 0x101, 70, 2162689,, ahk_pid %PID%
			sleep, 1
			}
			}
			else if(Key = "g"){
			loop, 1 {
			PostMessage, 0x100, 71, 2228225,, ahk_pid %PID%
			PostMessage, 0x101, 71, 2228225,, ahk_pid %PID%
			sleep, 1
			}
			}
			else if(Key = "h"){
			loop, 1 {
			PostMessage, 0x100, 72, 2293761,, ahk_pid %PID%
			PostMessage, 0x101, 72, 2293761,, ahk_pid %PID%
			sleep, 1
			}
			}
			else if(Key = "i"){
			loop, 1 {
			PostMessage, 0x100, 73, 1507329,, ahk_pid %PID%
			PostMessage, 0x101, 73, 1507329,, ahk_pid %PID%
			sleep, 1
			}
			}
			else if(Key = "j"){
			loop, 1 {
			PostMessage, 0x100, 74, 2359297,, ahk_pid %PID%
			PostMessage, 0x101, 74, 2359297,, ahk_pid %PID%
			sleep, 1
			}
			}
			else if(Key = "k"){
			loop, 1 {
			PostMessage, 0x100, 75, 2424833,, ahk_pid %PID%
			PostMessage, 0x101, 75, 2424833,, ahk_pid %PID%
			sleep, 1
			}
			}
			else if(Key = "l"){
			loop, 1 {
			PostMessage, 0x100, 76, 2490369,, ahk_pid %PID%
			PostMessage, 0x101, 76, 2490369,, ahk_pid %PID%
			sleep, 1
			}
			}
			else if(Key = "m"){
			loop, 1 {
			PostMessage, 0x100, 77, 3276801,, ahk_pid %PID%
			PostMessage, 0x101, 77, 3276801,, ahk_pid %PID%
			sleep, 1
			}
			}
			else if(Key = "n"){
			loop, 1 {
			PostMessage, 0x100, 78, 3211265,, ahk_pid %PID%
			PostMessage, 0x101, 78, 3211265,, ahk_pid %PID%
			sleep, 1
			}
			}
			else if(Key = "o"){
			loop, 1 {
			PostMessage, 0x100, 79, 1572865,, ahk_pid %PID%
			PostMessage, 0x101, 79, 1572865,, ahk_pid %PID%
			sleep, 1
			}
			}
			else if(Key = "p"){
			loop, 1 {
			PostMessage, 0x100, 80, 1638401,, ahk_pid %PID%
			PostMessage, 0x101, 80, 1638401,, ahk_pid %PID%
			sleep, 1
			}
			}
			else if(Key = "q"){
			loop, 1 {
			PostMessage, 0x100, 81, 1048577,, ahk_pid %PID%
			PostMessage, 0x101, 81, 1048577,, ahk_pid %PID%
			sleep, 1
			}
			}
			else if(Key = "r"){
			loop, 1 {
			PostMessage, 0x100, 82, 1245185,, ahk_pid %PID%
			PostMessage, 0x101, 82, 1245185,, ahk_pid %PID%
			sleep, 1
			}
			}
			else if(Key = "s"){
			loop, 1 {
			PostMessage, 0x100, 83, 2031617,, ahk_pid %PID%
			PostMessage, 0x101, 83, 2031617,, ahk_pid %PID%
			sleep, 1
			}
			}
			else if(Key = "t"){
			loop, 1 {
			PostMessage, 0x100, 84, 1310721,, ahk_pid %PID%
			PostMessage, 0x101, 84, 1310721,, ahk_pid %PID%
			sleep, 1
			}
			}
			else if(Key = "u"){
			loop, 1 {
			PostMessage, 0x100, 85, 1441793,, ahk_pid %PID%
			PostMessage, 0x101, 85, 1441793,, ahk_pid %PID%
			sleep, 1
			}
			}
			else if(Key = "v"){
			loop, 1 {
			PostMessage, 0x100, 86, 3080193,, ahk_pid %PID%
			PostMessage, 0x101, 86, 3080193,, ahk_pid %PID%
			sleep, 1
			}
			}
			else if(Key = "w"){
			loop, 1 {
			PostMessage, 0x100, 87, 1114113,, ahk_pid %PID%
			PostMessage, 0x101, 87, 1114113,, ahk_pid %PID%
			sleep, 1
			}
			}
			else if(Key = "x"){
			loop, 1 {
			PostMessage, 0x100, 88, 2949121,, ahk_pid %PID%
			PostMessage, 0x101, 88, 2949121,, ahk_pid %PID%
			sleep, 1
			}
			}
			else if(Key = "y"){
			loop, 1 {
			PostMessage, 0x100, 89, 1376257,, ahk_pid %PID%
			PostMessage, 0x101, 89, 1376257,, ahk_pid %PID%
			sleep, 1
			}
			}
			else if(Key = "z"){
			loop, 1 {
			PostMessage, 0x100, 90, 2883585,, ahk_pid %PID%
			PostMessage, 0x101, 90, 2883585,, ahk_pid %PID%
			sleep, 1
			}
			}
			else if(Key = "AltR"){
			loop, 1 {
			PostMessage, 0x100, 18, 540540929,, ahk_pid %PID% ; ALT Lock
			PostMessage, 0x100, 82, 1245185,, ahk_pid %PID%  ; r Lock
			PostMessage, 0x101, 82, 1245185,, ahk_pid %PID%  ; r release
			PostMessage, 0x101, 18, 540540929,, ahk_pid %PID% ; ALT Release
			sleep, 1
			}
			}
			else if(Key = "Space"){
			loop, 1 {
			PostMessage, 0x100, 32, 3735553,, ahk_pid %PID%
			PostMessage, 0x101, 32, 3735553,, ahk_pid %PID%
			}
			}
			else if(Key = "Tab"){
			loop, 1 {
			PostMessage, 0x100, 9, 983041,, ahk_pid %PID%
			PostMessage, 0x101, 9, 983041,, ahk_pid %PID%
			}
			}
			else if(Key = "Alt2"){
			loop, 1 {
			PostMessage, 0x100, 18, 540540929,, ahk_pid %PID% ; ALT Lock
			postmessage, 0x100, 50, 196609, ,ahk_pid %PID% ; 2 Key Lock
			postmessage, 0x101, 50, 196609, ,ahk_pid %PID% ; 2 Key Release
			PostMessage, 0x101, 18, 540540929,, ahk_pid %PID% ; ALT Release
			sleep, 1
			}
			}
			else if (Key>=0&&KEY<=9){
			if (key=0)
			key := 10
			NUM := key - 1
			mem.write(0x005279CD, NUM, "Char", aOffsets*)
			RunMemory("퀵슬롯사용")
			}
			else if(Key="F1"){
			if (mem.read(0x0058EBC8,"Uint",0x140,0x0) != 0)
				KeyClick("Enter")
			loop, 1 {
			postmessage, 0x100, 112, 3866625, ,ahk_pid %PID%
			postmessage, 0x101, 112, 3866625, ,ahk_pid %PID%
			sleep, 1
			}
			}
			else if(Key="F2"){
			if (mem.read(0x0058EBC8,"Uint",0x140,0x0) != 0)
				KeyClick("Enter")
			loop, 1 {
			postmessage, 0x100, 113, 3932161, ,ahk_pid %PID%
			postmessage, 0x101, 113, 3932161, ,ahk_pid %PID%
			sleep, 1
			}
			}
			else if(Key="F3"){
			if (mem.read(0x0058EBC8,"Uint",0x140,0x0) != 0)
				KeyClick("Enter")
			loop, 1 {
			postmessage, 0x100, 114, 3997697, ,ahk_pid %PID%
			postmessage, 0x101, 114, 3997697, ,ahk_pid %PID%
			sleep, 1
			}
			}
			else if(Key="k1"){
			if (mem.read(0x0058EBC8,"Uint",0x140,0x0) != 0)
				KeyClick("Enter")
			loop, 1 {
			postmessage, 0x100, 49, 131073, ,ahk_pid %PID% ; 1 Key Lock
			postmessage, 0x101, 49, 131073, ,ahk_pid %PID% ; 1 Key Release
			sleep, 1
			}
			}
			else if(Key="k2") {
			if (mem.read(0x0058EBC8,"Uint",0x140,0x0) != 0)
				KeyClick("Enter")
			loop, 1 {
			postmessage, 0x100, 50, 196609, ,ahk_pid %PID% ; 2 Key Lock
			postmessage, 0x101, 50, 196609, ,ahk_pid %PID% ; 2 Key Release
			sleep, 1
			}
			}
			else if(Key="k3") {
			if (mem.read(0x0058EBC8,"Uint",0x140,0x0) != 0)
				KeyClick("Enter")
			loop, 1 {
			postmessage, 0x100, 51, 262145, ,ahk_pid %PID% ; 3 Key Lock
			postmessage, 0x101, 51, 262145, ,ahk_pid %PID% ; 3 Key Release
			sleep, 1
			}
			}
			else if(Key="k4") {
			if (mem.read(0x0058EBC8,"Uint",0x140,0x0) != 0)
				KeyClick("Enter")
			loop, 1 {
			postmessage, 0x100, 52, 327681, ,ahk_pid %PID% ; 4 Key Lock
			postmessage, 0x101, 52, 327681, ,ahk_pid %PID% ; 4 Key Release
			sleep, 1
			}
			}
			else if(Key="k5"){
			if (mem.read(0x0058EBC8,"Uint",0x140,0x0) != 0)
				KeyClick("Enter")
			loop, 1{
			postmessage, 0x100, 53, 393217, ,ahk_pid %PID% ; 5 Key Lock
			postmessage, 0x101, 53, 393217, ,ahk_pid %PID% ; 5 Key Release
			sleep, 1
			}
			}
			else if(Key="k6"){
			if (mem.read(0x0058EBC8,"Uint",0x140,0x0) != 0)
				KeyClick("Enter")
			loop, 1{
			postmessage, 0x100, 54, 458753, ,ahk_pid %PID% ; 6 Key Lock
			postmessage, 0x101, 54, 458753, ,ahk_pid %PID% ; 6 Key Release
			sleep, 1
			}
			}
			else if(Key="k7"){
			if (mem.read(0x0058EBC8,"Uint",0x140,0x0) != 0)
				KeyClick("Enter")
			loop, 1{
			postmessage, 0x100, 55, 524289, ,ahk_pid %PID% ; 7 Key Lock
			postmessage, 0x101, 55, 524289, ,ahk_pid %PID% ; 7 Key Release
			sleep, 1
			}
			}
			else if(Key="k8"){
			if (mem.read(0x0058EBC8,"Uint",0x140,0x0) != 0)
				KeyClick("Enter")
			loop, 1{
			postmessage, 0x100, 56, 589825, ,ahk_pid %PID% ; 8 Key Lock
			postmessage, 0x101, 56, 589825, ,ahk_pid %PID% ; 8 Key Release
			sleep, 1
			}
			}
			else if(Key="k9"){
			if (mem.read(0x0058EBC8,"Uint",0x140,0x0) != 0)
				KeyClick("Enter")
			loop, 1{
			postmessage, 0x100, 57, 655361, ,ahk_pid %PID% ; 9 Key Lock
			postmessage, 0x101, 57, 655361, ,ahk_pid %PID% ; 9 Key Release
			sleep, 1
			}
			}
			else if(Key="k0"){
			if (mem.read(0x0058EBC8,"Uint",0x140,0x0) != 0)
				KeyClick("Enter")
			loop, 1{
			postmessage, 0x100, 48, 720897, ,ahk_pid %PID% ; 0 Key Lock
			postmessage, 0x101, 48, 720897, ,ahk_pid %PID% ; 0 Key Release
			sleep, 1
			}
			}
			else if(Key="CTRL1"){
			loop, 1 {
			postmessage, 0x100, 17, 1900545, ,ahk_pid %PID% ; CTRL Lock
			postmessage, 0x100, 49, 131073, ,ahk_pid %PID% ; 1 Key Lock
			postmessage, 0x101, 49, 131073, ,ahk_pid %PID% ; 1 Key Release
			postmessage, 0x101, 17, 1900545, ,ahk_pid %PID% ; CTRL Release
			sleep, 1
			}
			}
			else if(Key="CTRL2"){
			loop, 1 {
			postmessage, 0x100, 17, 1900545, ,ahk_pid %PID% ; CTRL Lock
			postmessage, 0x100, 50, 196609, ,ahk_pid %PID% ; 2 Key Lock
			postmessage, 0x101, 50, 196609, ,ahk_pid %PID% ; 2 Key Release
			postmessage, 0x101, 17, 1900545, ,ahk_pid %PID% ; CTRL Release
			sleep, 1
			}
			}
			else if(Key="CTRL3") {
			loop, 1 {
			postmessage, 0x100, 17, 1900545, ,ahk_pid %PID% ; CTRL Lock
			postmessage, 0x100, 51, 262145, ,ahk_pid %PID% ; 3 Key Lock
			postmessage, 0x101, 51, 262145, ,ahk_pid %PID% ; 3 Key Release
			postmessage, 0x101, 17, 1900545, ,ahk_pid %PID% ; CTRL Release
			sleep, 1
			}
			}
			else if(Key="CTRL4") {
			loop, 1 {
			postmessage, 0x100, 17, 1900545, ,ahk_pid %PID% ; CTRL Lock
			postmessage, 0x100, 52, 327681, ,ahk_pid %PID% ; 4 Key Lock
			postmessage, 0x101, 52, 327681, ,ahk_pid %PID% ; 4 Key Release
			postmessage, 0x101, 17, 1900545, ,ahk_pid %PID% ; CTRL Release
			sleep, 1
			}
			}
			else if(Key="CTRL5") {
			loop, 1 {
			postmessage, 0x100, 17, 1900545, ,ahk_pid %PID% ; CTRL Lock
			postmessage, 0x100, 53, 393217, ,ahk_pid %PID% ; 5 Key Lock
			postmessage, 0x101, 53, 393217, ,ahk_pid %PID% ; 5 Key Release
			postmessage, 0x101, 17, 1900545, ,ahk_pid %PID% ; CTRL Release
			sleep, 1
			}
			}
			else if(Key="CTRL6") {
			loop, 1 {
			postmessage, 0x100, 17, 1900545, ,ahk_pid %PID% ; CTRL Lock
			postmessage, 0x100, 54, 458753, ,ahk_pid %PID% ; 6 Key Lock
			postmessage, 0x101, 54, 458753, ,ahk_pid %PID% ; 6 Key Release
			postmessage, 0x101, 17, 1900545, ,ahk_pid %PID% ; CTRL Release
			sleep, 1
			}
			}
			else if(Key="CTRL7") {
			loop, 1 {
			postmessage, 0x100, 17, 1900545, ,ahk_pid %PID% ; CTRL Lock
			postmessage, 0x100, 55, 524289, ,ahk_pid %PID% ; 7 Key Lock
			postmessage, 0x101, 55, 524289, ,ahk_pid %PID% ; 7 Key Release
			postmessage, 0x101, 17, 1900545, ,ahk_pid %PID% ; CTRL Release
			sleep, 1
			}
			}
			else if(Key="CTRL8") {
			loop, 1 {
			postmessage, 0x100, 17, 1900545, ,ahk_pid %PID% ; CTRL Lock
			postmessage, 0x100, 56, 589825, ,ahk_pid %PID% ; 8 Key Lock
			postmessage, 0x101, 56, 589825, ,ahk_pid %PID% ; 8 Key Release
			postmessage, 0x101, 17, 1900545, ,ahk_pid %PID% ; CTRL Release
			sleep, 1
			}
			}
			else if(Key="CTRL9") {
			loop, 1 {
			postmessage, 0x100, 17, 1900545, ,ahk_pid %PID% ; CTRL Lock
			postmessage, 0x100, 57, 655361, ,ahk_pid %PID% ; 9 Key Lock
			postmessage, 0x101, 57, 655361, ,ahk_pid %PID% ; 9 Key Release
			postmessage, 0x101, 17, 1900545, ,ahk_pid %PID% ; CTRL Release
			sleep, 1
			}
			}
			else if(Key="CTRL0") {
			loop, 1 {
			postmessage, 0x100, 17, 1900545, ,ahk_pid %PID% ; CTRL Lock
			postmessage, 0x100, 48, 720897, ,ahk_pid %PID% ; 0 Key Lock
			postmessage, 0x101, 48, 720897, ,ahk_pid %PID% ; 0 Key Release
			postmessage, 0x101, 17, 1900545, ,ahk_pid %PID% ; CTRL Release
			sleep, 1
			}
			}
			else if(Key="DownArrow") {
			loop, 1 {
			postmessage, 0x100, 40, 22020097, ,ahk_pid %PID% ; 하향 키 Lock
			postmessage, 0x101, 40, 22020097, ,ahk_pid %PID% ; 하향 키 Release
			sleep, 1
			}
			}
			else if(Key="UpArrow") {
			loop, 1 {
			postmessage, 0x100, 38, 21495809, ,ahk_pid %PID% ; 상향 키 Lock
			postmessage, 0x101, 38, 21495809, ,ahk_pid %PID% ; 상향 키 Release
			sleep, 1
			}
			}
			else if(Key="RightArrow") {
			loop, 1 {
			postmessage, 0x100, 39, 21823489, ,ahk_pid %PID% ; 오른쪽 키 Lock
			postmessage, 0x101, 39, 21823489, ,ahk_pid %PID% ; 오른쪽 키 Release
			sleep, 1
			}
			}
			else if(Key="LeftArrow") {
			loop, 1 {
			postmessage, 0x100, 37, 21692417, ,ahk_pid %PID% ; 오른쪽 키 Lock
			postmessage, 0x101, 37, 21692417, ,ahk_pid %PID% ; 오른쪽 키 Release
			sleep, 1
			}
			}
		}

		IME_CHECK(WinTitle) ;현재 "한/영" 키 확인 함수  Status := % IME_CHECK("A") 에서 Status = 0 을 반환한다면, Send, {vk15sc138} 을 통해 한글전환 필요
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

		MouseClick(MouseX,MouseY)  ; 지정한 X, Y 좌표 마우스왼쪽버튼으로 클릭
		{
			PID := TargetPID
			if (Multiplyer = "없음" || Multiplyer < 1)
				gosub, 일랜시아창크기구하기
			MouseX := MouseX * Multiplyer
			MouseY := MouseY * Multiplyer
			MousePos := MouseX|MouseY<< 16
			PostMessage, 0x200, 0, %MousePos% ,,ahk_pid %PID%
			PostMessage, 0x201, 1, %MousePos% ,,ahk_pid %PID%
			PostMessage, 0x202, 0, %MousePos% ,,ahk_pid %PID%
		}

		MouseDoubleClickLeftButton(MouseX,MouseY) ; 지정한 X, Y 좌표 마우스왼쪽버튼으로 더블클릭
		{
			PID := TargetPID
			if (Multiplyer = "없음" || Multiplyer < 1)
				gosub, 일랜시아창크기구하기
			MouseX := MouseX * Multiplyer
			MouseY := MouseY * Multiplyer
			MousePos := MouseX | MouseY << 16
			PostMessage, 0x200, 1, %MousePos% ,,ahk_pid %PID%
			PostMessage, 0x203, 1, %MousePos% ,,ahk_pid %PID%
			PostMessage, 0x202, 0, %MousePos% ,,ahk_pid %PID%
		}

		MouseClickRightButton(MouseX,MouseY) ; 지정한 X, Y 좌표 마우스오른쪽버튼으로 클릭
		{
			PID := TargetPID
			if (Multiplyer = "없음" || Multiplyer < 1)
				gosub, 일랜시아창크기구하기
			MouseX := MouseX * Multiplyer
			MouseY := MouseY * Multiplyer
			MousePos := MouseX | MouseY << 16
			PostMessage, 0x200, 0, %MousePos% ,,ahk_pid %PID%
			PostMessage, 0x204, 1, %MousePos% ,,ahk_pid %PID%
			PostMessage, 0x205, 0, %MousePos% ,,ahk_pid %PID%
		}

		MouseMoveTo(MouseX,MouseY) ; 마우스포인터를 지정한 X, Y 좌표로 이동
		{
			PID := TargetPID
			if (Multiplyer = "없음" || Multiplyer < 1)
				gosub, 일랜시아창크기구하기
			MouseX := MouseX * Multiplyer
			MouseY := MouseY * Multiplyer
			MousePos := MouseX | MouseY << 16
			PostMessage, 0x200, 0, %MousePos% ,,ahk_pid %PID%
		}

	;}

	;{ ; 일랜시아 프로그램; 캐릭명 읽어오기 함수
		GetOidFromOtherElancia(ProgramWindowTitle) ;지정된 이름을 가진 일랜시아프로그램 접속 캐릭터의 OID 가져오기
		{
			Start_Scan := 0
			player_id := 0
			WinGet, temp_pid, PID, %ProgramWindowTitle%
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

		GetAllElanciaTitle(TitleNumber) ;현재 실행중인 모든 Nexon.Elancia 속성의 프로그램명 가져와서 파티원 리스트에 추가하기
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

		ReadAllElanciaTitle() ;현재 실행중인 모든 Nexon.Elancia 속성의 프로그램명 가져와서 캐릭터 선택 리스트에 추가하기
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

	;}

	;{ ; 치트엔진 코드 적용 함수

		CheatEngine_NoLimitMovementDuringCook() ;게임핵: 제작시 이동가능
		{
			mem.write(0x00431D4F,0x90,"char",aOffset*)
			mem.write(0x00431D50,0x90,"char",aOffset*)
			mem.write(0x00431D51,0x90,"char",aOffset*)
			mem.write(0x00431D52,0x90,"char",aOffset*)
			mem.write(0x00431D53,0x90,"char",aOffset*)

			mem.write(0x00470D53,0x68,"char",aOffset*)
			mem.write(0x00470D54,0x01,"char",aOffset*)
			mem.write(0x00470D55,0x00,"char",aOffset*)
			mem.write(0x00470D56,0x00,"char",aOffset*)
			mem.write(0x00470D57,0x00,"char",aOffset*)
		}
		CheatEngine_CancelNoLimitMovementDuringCook() ;게임핵: 제작시 이동가능
		{
			mem.write(0x00431D4F,0xE8,"char",aOffset*)
			mem.write(0x00431D50,0x47,"char",aOffset*)
			mem.write(0x00431D51,0x27,"char",aOffset*)
			mem.write(0x00431D52,0x06,"char",aOffset*)
			mem.write(0x00431D53,0x00,"char",aOffset*)

			mem.write(0x00470D53,0x68,"char",aOffset*)
			mem.write(0x00470D54,0xB8,"char",aOffset*)
			mem.write(0x00470D55,0x0B,"char",aOffset*)
			mem.write(0x00470D56,0x00,"char",aOffset*)
			mem.write(0x00470D57,0x00,"char",aOffset*)
		}
		CheatEngine_AttackAlwaysPerFect() ;게임핵: 항상 Perfect 하기 - 2배의 데미지
		{
			mem.write(0x004cfbc5,0xa2,"char",aOffset*)
			mem.write(0x004d05cd,0xa2,"char",aOffset*)
		}

		CheatEngine_AttackAlwaysNormal() ;기본 상태로 초기화 - 1배의 데미지
		{
			mem.write(0x004cfbc5,0xb6,"char",aOffset*)
			mem.write(0x004d05cd,0xb6,"char",aOffset*)
		}

		CheatEngine_AttackAlwaysMiss() ;게임핵: 항상 Miss 하기 - 0.5배의 데미지
		{
			mem.write(0x004cfbc5,0xb2,"char",aOffset*)
			mem.write(0x004d05cd,0xb2,"char",aOffset*)
		}

		CheatEngine_NoAttackMotion() ;게임핵: 공격모션 제거 - 빠른 공격
		{
			mem.write(0x0047C1A9,0x6A,"char",aOffset*)
			mem.write(0x0047C1AA,0x00,"char",aOffset*)
			mem.write(0x0047C1AB,0x90,"char",aOffset*)
			mem.write(0x0047C1AC,0x90,"char",aOffset*)
			mem.write(0x0047C1AD,0x90,"char",aOffset*)
		}

		CheatEngine_NoShowRide() ; 게임핵: 탈것 안보이기 - 이동불가 체력회복용 탈것 장착상태로 이동 가능
		{
			mem.write(0x0046035B,0x90,"char",aOffset*)
			mem.write(0x0046035C,0x90,"char",aOffset*)
			mem.write(0x0046035D,0x90,"char",aOffset*)
			mem.write(0x0046035E,0x90,"char",aOffset*)
			mem.write(0x0046035F,0x90,"char",aOffset*)
			mem.write(0x00460360,0x90,"char",aOffset*)
		}

		CheatEngine_ShowRide() ; 게임핵: 탈것 보이기 -
		{
			mem.write(0x0046035B,0x89,"char",aOffset*)
			mem.write(0x0046035C,0x83,"char",aOffset*)
			mem.write(0x0046035D,0x6B,"char",aOffset*)
			mem.write(0x0046035E,0x01,"char",aOffset*)
			mem.write(0x0046035F,0x00,"char",aOffset*)
			mem.write(0x00460360,0x00,"char",aOffset*)
		}

		CheatEngine_NoShowChar() ; 게임핵: 케릭제거
		{
			mem.write(0x0045D28F,0xE9,"char",aOffset*)
			mem.write(0x0045D290,0x8A,"char",aOffset*)
			mem.write(0x0045D291,0x0A,"char",aOffset*)
			mem.write(0x0045D292,0x00,"char",aOffset*)
			mem.write(0x0045D293,0x00,"char",aOffset*)
		}

		CheatEngine_ShowChar() ; 게임핵: 케릭제거
		{
			mem.write(0x0045D28F,0x0F,"char",aOffset*)
			mem.write(0x0045D290,0x84,"char",aOffset*)
			mem.write(0x0045D291,0xC2,"char",aOffset*)
			mem.write(0x0045D292,0x00,"char",aOffset*)
			mem.write(0x0045D293,0x00,"char",aOffset*)
		}

		CheatEngine_NoShowBack() ; 게임핵: 배경제거
		{
			mem.write(0x0047A18D,0xEB,"char",aOffset*)
		}

		CheatEngine_ShowBack() ; 게임핵: 배경보기
		{
			mem.write(0x0047A18D,0x75,"char",aOffset*)
		}

		CheatEngine_NoShowBlock() ; 게임핵: 환경이미지 제거
		{
			mem.write(0x0047aa20,0xEB,"char",aOffset*)
		}

		CheatEngine_ShowBlock() ; 게임핵: 환경이미지 보기
		{
			mem.write(0x0047aa20,0x74,"char",aOffset*)
		}

		CheatEngine_NoShowShield() ; 게임핵: 방패 안보이기
		{
			mem.write(0x0045DA94,0x90,"char",aOffset*)
			mem.write(0x0045DA95,0x90,"char",aOffset*)
			mem.write(0x0045DA96,0x90,"char",aOffset*)
		}

		CheatEngine_ShowShield() ; 게임핵: 방패 보이기
		{
			mem.write(0x0045DA94,0x89,"char",aOffset*)
			mem.write(0x0045DA95,0x43,"char",aOffset*)
			mem.write(0x0045DA96,0x4C,"char",aOffset*)
		}

		CheatEngine_NoShowWeapon() ; 게임핵: 무기 안보이기
		{
			mem.write(0x0045D98B,0x90,"char",aOffset*)
			mem.write(0x0045D98C,0x90,"char",aOffset*)
			mem.write(0x0045D98D,0x90,"char",aOffset*)
		}

		CheatEngine_ShowWeapon() ; 게임핵: 무기 보이기
		{
			mem.write(0x0045D98B,0x89,"char",aOffset*)
			mem.write(0x0045D98C,0x43,"char",aOffset*)
			mem.write(0x0045D98D,0x44,"char",aOffset*)
		}


		CheatEngine_AllwaysShowMinimap() ; 항상 미니맵이 맵을 보이게 하기, 일부 맵에서 미니맵 비공개하는 것을 비활성화
		{
			mem.write(0x04766E0, 0xB0, "Char",aOffsets*)
			mem.write(0x04766E1, 0x01, "Char",aOffsets*)
			mem.write(0x04766E2, 0x90, "Char",aOffsets*)
			mem.write(0x04766E3, 0x90, "Char",aOffsets*)
			mem.write(0x04766E4, 0x90, "Char",aOffsets*)
			mem.write(0x04766E5, 0x90, "Char",aOffsets*)
		}

		CheatEngine_MoveSpeedTo(Speed) ; 달리기, 걷기, 헤엄치기의 속도를 원하는 속도로 변경
		{
			;이동속도 변경 방지1 미니맵 클릭 불가
			mem.write(mem.getModuleBaseAddress("jelancia_core.dll")+0x7F51, 0x90, "Char",aOffsets*)
			mem.write(mem.getModuleBaseAddress("jelancia_core.dll")+0x7F52, 0x90, "Char",aOffsets*)
			mem.write(mem.getModuleBaseAddress("jelancia_core.dll")+0x7F53, 0x90, "Char",aOffsets*)
			mem.write(mem.getModuleBaseAddress("jelancia_core.dll")+0x7F54, 0x90, "Char",aOffsets*)
			mem.write(mem.getModuleBaseAddress("jelancia_core.dll")+0x7F55, 0x90, "Char",aOffsets*)
			mem.write(mem.getModuleBaseAddress("jelancia_core.dll")+0x7F56, 0x90, "Char",aOffsets*)
			;이동속도 변경 방지2
			mem.write(mem.getModuleBaseAddress("jelancia_core.dll")+0x6837, 0x90, "Char",aOffsets*)
			mem.write(mem.getModuleBaseAddress("jelancia_core.dll")+0x6838, 0x90, "Char",aOffsets*)
			mem.write(mem.getModuleBaseAddress("jelancia_core.dll")+0x6839, 0x90, "Char",aOffsets*)
			mem.write(mem.getModuleBaseAddress("jelancia_core.dll")+0x683A, 0x90, "Char",aOffsets*)
			mem.write(mem.getModuleBaseAddress("jelancia_core.dll")+0x683B, 0x90, "Char",aOffsets*)
			mem.write(mem.getModuleBaseAddress("jelancia_core.dll")+0x683C, 0x90, "Char",aOffsets*)
			;이동속도 변경 방지3
			mem.write(0x004B8944, 0x90, "Char",aOffsets*)
			mem.write(0x004B8945, 0x90, "Char",aOffsets*)
			mem.write(0x004B8946, 0x90, "Char",aOffsets*)
			mem.write(0x004B8947, 0x90, "Char",aOffsets*)
			mem.write(0x004B8948, 0x90, "Char",aOffsets*)
			mem.write(0x004B8949, 0x90, "Char",aOffsets*)
			if( mem.read(0x0058DAD4, "UInt", 0x178, 0x9C) != Speed)
				mem.write(0x0058DAD4, Speed, "UInt", 0x178, 0x9C) ;달리기
			;이동속도 변경 방지4
			mem.write(0x004B892C, 0x90, "Char",aOffsets*)
			mem.write(0x004B892D, 0x90, "Char",aOffsets*)
			mem.write(0x004B892E, 0x90, "Char",aOffsets*)
			mem.write(0x004B892F, 0x90, "Char",aOffsets*)
			mem.write(0x004B8930, 0x90, "Char",aOffsets*)
			mem.write(0x004B8931, 0x90, "Char",aOffsets*)
			if( mem.read(0x0058DAD4, "UInt", 0x178, 0x98) != Speed)
				mem.write(0x0058DAD4, Speed, "UInt", 0x178, 0x98) ;걷기
			if( mem.read(0x0058DAD4, "UInt", 0x178, 0xa4) != Speed)
				mem.write(0x0058DAD4, Speed, "UInt", 0x178, 0xa4) ;헤엄치기
		}

		CheatEngine_GameSpeedTo(배속)
		{
			/*
			MRM 님의 블로그에 공유해주신 스피드핵 CT 입니다.
				define(speedhack,58FF80)
				fullaccess(speedhack,200)
				define(time,58FF9A)
				define(ChangeSpeed,0058FFE0)
				registersymbol(ChangeSpeed)

				0040FB07:
				jmp speedhack

				speedhack:
				mov edi,[ChangeSpeed]
				add [time],edi
				add eax,[time]
				mov [esi+6C],eax
				jmp 0040FB49

				time:
				dd 0 0

				ChangeSpeed:
				dd #0

			0040FB07 를 E9 74 04 18 00 로 변경해야함
			만약 0040FB07 의 값이 402945257 이 아니라면
			0040FB07의 값을 바꿔야함
			그리고 배속함수를 써줘야함
			시간 0058FF9A 32bytes
			배속 0058FFE0 4bytes
			배속 0 추천이동속도 180
			배속 40 추천이동속도 1650
			유져가 배속을 변경했거나 혹은 추천이동속도가 게임내에서 자동으로 변경되었다면,
			해당 변경사항을 게임에 적용해야함
			현재 게임 속도를 읽어서 0058FFE0 가 설정된 게임 배속이 아니라면 다시 변경하고
			이동속도도 동일
			예제결과물 )
			if ( mem.read(0x0040FB07,"Uint", aOffsets*) != 402945257 ) ; 0x180474E9
			{
			mem.write(0x0040FB07,0xE9,"Char", aOffsets*)
			mem.write(0x0040FB08,0x74,"Char", aOffsets*)
			mem.write(0x0040FB09,0x04,"Char", aOffsets*)
			mem.write(0x0040FB0A,0x18,"Char", aOffsets*)
			mem.write(0x0040FB0B,0x00,"Char", aOffsets*)
			WriteExecutableMemory("게임내시간제어")
			CheatEngine_GameSpeedTo(게임배속)
			}
			*/

			if (mem.read(0x0058FFE0,"UInt", aOffsets*) != 배속)
			{
				mem.write(0x0058FFE0,배속,"UInt", aOffsets*)
			}
		}

		TwoWeaponChangeAndPunch() ; 2벗무바활성화
		{
			/*
			[ENABLE]
			jElancia.exe+CBE8D:
			JMP mubamuba
			ret
			*/
			mem.write(0x004CBE8D, 0xE9, "char", aOffsets*)
			mem.write(0x004CBE8E, 0xAE, "char", aOffsets*)
			mem.write(0x004CBE8F, 0xF8, "char", aOffsets*)
			mem.write(0x004CBE90, 0x12, "char", aOffsets*)
			mem.write(0x004CBE91, 0x00, "char", aOffsets*)
			mem.write(0x004CBE92, 0xC3, "char", aOffsets*)

		}

		CancelTwoWeaponChangeAndPunch() ; 2벗무바비활성화
		{
			/*
			[DISABLE]
			jElancia.exe+CBE8D:
			mov [ebp+000001A4],eax
			*/
			mem.write(0x004CBE8D, 0x89, "char", aOffsets*)
			mem.write(0x004CBE8E, 0x85, "char", aOffsets*)
			mem.write(0x004CBE8F, 0xA4, "char", aOffsets*)
			mem.write(0x004CBE90, 0x01, "char", aOffsets*)
			mem.write(0x004CBE91, 0x00, "char", aOffsets*)
			mem.write(0x004CBE92, 0x00, "char", aOffsets*)

		}

		CheatEngine_DoNotMove() ; 캐릭터의 이동을 제한
		{
			mem.write(0x0047AD78, 0x90, "char", aOffsets*)
			mem.write(0x0047AD79, 0x90, "char", aOffsets*)
			mem.write(0x0047AD7A, 0x90, "char", aOffsets*)
		}

		CheatEngine_CancelDoNotMove() ; 캐릭터 이동 제한 해제
		{
			mem.write(0x0047AD78, 0x8B, "char", aOffsets*)
			mem.write(0x0047AD79, 0x4E, "char", aOffsets*)
			mem.write(0x0047AD7A, 0x04, "char", aOffsets*)
		}

		CheatEngine_Move_Buy() ; 구매창을 기 설정된 위치로 이동
		{
			mem.write(0x0058EB48, 233, "UInt", 0x8C)
			mem.write(0x0058EB48, 173, "UInt", 0x90)
		}

		CheatEngine_Move_Sell() ; 판매창을 기 설정된 위치로 이동
		{
			mem.write(0x0058EB48, 233, "UInt", 0x98)
			mem.write(0x0058EB48, 173, "UInt", 0x9C)
		}

		CheatEngine_Move_Repair()  ; 수리창을 기 설정된 위치로 이동
		{
			mem.write(0x0058EB48, 230, "UInt", 0xA4)
			mem.write(0x0058EB48, 170, "UInt", 0xA8)
		}

		CheatEngine_Buy_Unlimitted() ; 구매하기를 클릭해도 구매는 이루어지되 반응은 없도록 변경
		{
			mem.write(0x0042483A, 0xB0, "char", aOffsets*)
			mem.write(0x0042483B, 0x01, "char", aOffsets*)
			mem.write(0x0042483C, 0x90, "char", aOffsets*)
			mem.write(0x0042483D, 0x90, "char", aOffsets*)
			mem.write(0x0042483E, 0x90, "char", aOffsets*)
			mem.write(0x0042483F, 0x90, "char", aOffsets*)
		}
	;}

	;{ ; ListView, 배열, 혹은 매트릭스 관리용 함수;

		IsWordInList(word, list)
		{
			for _, item in list
			{
				if InStr(word, item)
				{
					return true
				}
			}
			return false
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

		GetLVRowByResult(result)
		{
			loop % LV_GetCount()
			{
				LV_GetText(currentResult, A_Index, 10) ; Assuming 'result' is in the 10th column
				if (currentResult == result)
					return A_Index
			}
			return -1 ; Return -1 if not found
		}

		GetLVRowByOID(OID)
		{
			loop % LV_GetCount()
			{
				LV_GetText(currentOID, A_Index, 6) ; Assuming 'result' is in the 10th column
				if (currentOID == OID)
					return A_Index
			}
			return -1 ; Return -1 if not found
		}

		GetMoreInformation()
		{
			STR := mem.read(0x0058DAD4, "UInt", 0x178, 0x2F)
			GuiControl,, STR, % STR

			AGI := mem.read(0x0058DAD4, "UInt", 0x178, 0x3F)
			GuiControl,, AGI, % AGI

			인트 := mem.read(0x0058DAD4, "UInt", 0x178, 0x33)
			GuiControl,, 인트, % 인트

			VIT := mem.read(0x0058DAD4, "UInt", 0x178, 0x3B)
			GuiControl,, VIT, % VIT

			FRAME := mem.read(0x0058DAD4, "UInt", 0x178, 0x47)
			GuiControl,, FRAME, % FRAME

			GALRID := mem.read(0x0058DAD4, "UInt", 0x178, 0x6F)
			GuiControl,, GALRID, % GALRID

			QUANTITY := mem.read(0x0058DAD4, "UInt", 0x178, 0xBE, 0x14)
			GuiControl,, QUANTITY, %QUANTITY% / 50

			VOTE := mem.read(0x0058DAD4, "UInt", 0x178, 0x4B)
			GuiControl,, VOTE, % VOTE
		}

	;}

	;{ ; 메모리 쓰기/실행하기 함수
		RunThread(Addrs)
		{
			Gui,Submit,Nohide
			PID := TargetPID

			if (STOPSIGN = true)
			{
				RT_Delay := A_TickCount - RunThreadCounter
				if (RT_Delay > 4000)
				{
					STOPSIGN := False
					sb_Settext("STOPSIGN 으로인한 대기끝",2)
				}
				else
					return
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
				WriteExecutableMemory("아이템줍기정지")
				SB_SetText("비정상",4)
				서버상태 := False
				return
			}
		}

		RunMemory(코드)
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
		gui,submit,nohide
		Run_Thread := 1
		Addrs := 0x00590740
		}
		else if (코드 = "공격하기") {
		gui,submit,nohide
		Run_Thread := 1
		Addrs := 0x00590700
		}
		else if (코드 = "좌표이동") {
		gui,submit,nohide
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
		return
		}

		WriteExecutableMemory(코드) ; 미리지정된 코드를 호출하면 입력하고 실행가능하도록 권한설정변경
		{
			; 변조할 메모리 위치, 크기, 내용 설정
			if (코드 = "은행넣기결정코드")  {
			Addrs := 0x00590005
			RegionSize := 0x200
			target = 8B0058DAD4A160808B000001788008408B000000BE32C283D231188D004D840FD2854A3B8304C3830000038BCB8BEF74008B08408B04588B02C083F63108408566FE0166388B0500058DF375FFC08310E6C1005966FE0166388B02F78966F375FF853966D98B10EEC100000110840FFEC361AAEB
			executable := mem.executable(Addrs, RegionSize)
			}
			else if (코드 = "게임내시간제어")  {
			Addrs := 0x0058FF80
			RegionSize := 0x200
			target = 010058FFE03D8B05030058FF9A3D6C46890058FF9AFFE7FBAFE9
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
			}
			else if (코드 = "아이템줍기정지") {
			Addrs := 0x00466A99
			target = C25DE58B5B5E5F
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
			target =
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
			target = C08500115479E9
			}
			else if (코드 = "아이템주소기록끄기") {
			Addrs := 0x0047B3D2
			target = 53E3F00446C756
			}
			else if (코드 = "아이템주소기록함수") {
			Addrs := 0x00590850
			RegionSize := 0x250
			target = 8B0059089C1D890389005908A01D04005908A0058108A03D810000007500590900005905C700401F0F0E5908A4005908A00059089C1D8B0045E92C2444895900000000FFEEAB
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
			else if (코드 = "공속"){
			Addrs := 0x00527B35
			RegionSize := 0x20
			target = 0D5ED90004668300003E000F46C7FFF38CD2E9
			executable := mem.executable(Addrs, RegionSize)
			}
			else if (코드 = "2벗무바"){
			Addrs := 0x005FB740
			RegionSize := 0x600
			target = 1D89005FB92BA34B0D89005FB93BB95B1589005FB95FB96B3589005F005FB97B3D89008B0058DAD4A1600539000001A58069840F005FB9135FB913A3000001005FB9233D830000000027840F0001005FB9233D838300000097840F0F02005FB9233D3D83000000A584840F03005FB9232705FF00000115B9273D83005FB900658C0F03005F5FB92305C7000005C70000000100000001005FB927BB000000F8B8000000BE00000001DED3E81E6A0000ED62F0E859FFEFE8FF438DF88BFF194788FFE88D4A448D502424448DE677CAE8501C24661824448B66FF24448B661A4789C78B1C47896624B3E9FFED6EBFE8D4BF006A000000EB8533E80058DA005FB92305C7FF0098E9000000025FB92705FF0000005FB9273D8300000000858C0F0301005FB92705C70000F8B8000000BE00000001BB00E81E6A0000000062E859FFEFDE45438DF88BFFED6288FFE88CBCE8FF502424448D19473CE8501C24448D24448B66FFE6778B661A478966181C478966242444FFED6E31E8C78B03005FB92305C700001BE900000058DAD4BF016A00C7FFEB849BE8000000005FB9230500000000E900008B005FB92BA1610D8B005FB93B1D5B158B005FB94BB96B358B005FB95FB97B3D8B005F000001A48589000000FFED0580E90000000000000000000000000000000001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
			executable := mem.executable(Addrs, RegionSize)
			/*
			FlyHigh 님 블로그에서 배포중인 메모리무바 기반;
			단, 배포중인 무바는 1ms 마다 메모리를 읽어오기 때문에 매우 비효율적이고, CPU 점유율이 너무 높아짐
			공격모션의 변경여부를 확인하는 것이 아닌 공격모션이 바뀌면 Hit이 증가되도록 변경

			// 임시 주소 정의
			define(mubamuba,005FB740)
			FullAccess(mubamuba,500)

			[ENABLE]
			jElancia.exe+CBE8D:
			JMP mubamuba
			ret

			mubamuba:
			mov [tempeax],eax
			mov [tempebx],ebx
			mov [tempecx],ecx
			mov [tempedx],edx
			mov [tempesi],esi
			mov [tempedi],edi
			pushad
			mov eax,[0058dad4]
			mov eax,[eax+1A5]
			cmp [lastnumber],eax
			je laststep // eax가 기존값과 같으면 원래 코드로 돌아감
			mov [lastnumber],eax
			cmp [step],0
			je step0
			cmp [step],1
			je step1
			cmp [step],2
			je step2
			cmp [step],3
			je step3

			step0:
			inc [hitcount] // 히트 카운터 증가
			cmp [hitcount],3
			jl notStepChange0
			mov [step],1 // 스텝을 1로 변경
			mov [hitcount],1
			mov eax,000000F8
			mov ebx,00000001
			mov esi,00000000
			push 1E
			call jElancia.exe+F96C4
			pop ecx
			call jElancia.exe+D1AE7
			mov edi,eax
			lea eax,[ebx-01]
			call jElancia.exe+8454B
			mov [edi+19],al
			lea eax,[esp+24]
			push eax
			lea eax,[esp+1C]
			push eax
			call jElancia.exe+62FDD
			mov ax,[esp+18]
			mov [edi+1A],ax
			mov ax,[esp+24]
			mov [edi+1C],ax
			mov eax,edi
			call jElancia.exe+D26EB
			notStepChange0:
			jmp laststep
			step1:
			push 0
			mov edi,0058DAD4
			call 004b3d70
			mov [step],2 // 스텝을 3으로 변경
			jmp laststep
			step2:
			inc [hitcount]
			cmp [hitcount], 3
			jl laststep
			mov [hitcount],1
			mov eax,000000F8
			mov ebx,00000001
			mov esi,00000000
			push 1E
			call jElancia.exe+F96C4
			pop ecx
			call jElancia.exe+D1AE7
			mov edi,eax
			lea eax,[ebx-01]
			call jElancia.exe+8454B
			mov [edi+19],al
			lea eax,[esp+24]
			push eax
			lea eax,[esp+1C]
			push eax
			call jElancia.exe+62FDD
			mov ax,[esp+18]
			mov [edi+1A],ax
			mov ax,[esp+24]
			mov [edi+1C],ax
			mov eax,edi
			call jElancia.exe+D26EB
			mov [step], 3 // 스텝을 3으로 변경
			notStepChange2:
			jmp laststep

			step3:
			push 1
			mov edi,0058DAD4
			call 004b3d70
			mov [step], 0 // 스텝을 0으로 변경
			jmp laststep

			laststep:
			popad
			mov eax,[tempeax]
			mov ebx,[tempebx]
			mov ecx,[tempecx]
			mov edx,[tempedx]
			mov esi,[tempesi]
			mov edi,[tempedi]
			mov [ebp+000001A4],eax
			jmp jElancia.exe+CBE93

			lastnumber:
			dd 00 00 00 00
			step:
			dd 00
			hitcount:
			dd 01
			tempeax:
			dd 00 00 00 00
			tempebx:
			dd 00 00 00 00
			tempecx:
			dd 00 00 00 00
			tempedx:
			dd 00 00 00 00
			tempesi:
			dd 00 00 00 00
			tempedi:
			dd 00 00 00 00

			[DISABLE]
			jElancia.exe+CBE8D:
			mov [ebp+000001A4],eax
			*/
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

		좌표입력(X,Y,Z)
		{
			X := Format("0x{:08X}", X)
			Y := Format("0x{:08X}", Y)
			Z := Format("0x{:08X}", Z)
			gosub, 기본정보읽기
			gui,submit,nohide
			if ( 맵번호 = 237 || 맵번호 = 1403 || 맵번호 = 2300 || 맵번호 = 3300 || 맵번호 =  3301 || 맵번호 =  11 ) ; 만약 광산이거나 농장이면
				Z := 1
			mem.write(0x00590600, X, "UInt", aOffsets*)
			mem.write(0x00590604, Y, "UInt", aOffsets*)
			mem.write(0x00590608, Z, "UInt", aOffsets*)
			return
		}

		스킬사용(스킬이름)
		{
			스킬번호 := 0
			Gui,ListView,어빌리티리스트
			임시이름 := 스킬이름 . "번호"
			GuiControlGet,스킬번호,, %임시이름%
			;SB_SetText("스킬이름" 임시이름 스킬번호, 2)
			if (스킬번호 != 0)
			{
				mem.write(0x0058D603, 스킬번호, "Char", aOffsets*)
				등록된스킬번호 := mem.read(0x0058D603, "Char", aOffsets*)
				if( 스킬번호 != 등록된스킬번호)
				{
					mem.write(0x0058D603, 스킬번호, "Char", aOffsets*)
					SB_SetText(스킬이름 "스킬에러" 스킬번호 "!=" 등록된스킬번호,2)
					ERROR := "스킬에러" . 스킬번호 . "!=" . 등록된스킬번호
				}
				임시이름 := 스킬이름 . "사용횟수"
				; 동적 변수 이름 사용
				GuiControlGet, 현재값,, %임시이름%
				임시횟수 := 현재값 + 1
				GuiControl,, %임시이름%, %임시횟수%
				RunMemory("스킬사용")
			}
			return
		}

		타겟스킬사용(타겟스킬이름, 대상)
		{
			;SB_SetText(타겟스킬이름 "," 대상, 2)
			Gui,ListView,어빌리티리스트
			타겟스킬번호 := 0
			타겟스킬대상 := 0
			if (대상 = "자신")
			{
				타겟스킬대상 := mem.read(0x0058DAD4, "UInt", 0x62)
			}
			else if (대상 = "클릭된대상")
				타겟스킬대상 := mem.read(0x00584C2C, "UInt", aOffsets*)
			else
				타겟스킬대상 := 대상

			임시이름 := 타겟스킬이름 . "번호"
			GuiControlGet, 타겟스킬번호,, %임시이름%
			if (타겟스킬번호 != 0 && 타겟스킬대상!= 0)
			{
				WriteExecutableMemory("타겟스킬호출")
				mem.write(0x0058FF3A, 타겟스킬번호, "Char", aOffsets*)
				등록된타겟스킬번호 := mem.read(0x0058FF3A, "Char", aOffsets*)
				if( 타겟스킬번호 != 등록된타겟스킬번호)
				{
					sleep,10
					mem.write(0x0058FF3A, 타겟스킬번호, "Char", aOffsets*)
					SB_SetText("타겟스킬에러",1)
				}
				mem.write(0x0058FF3B, 타겟스킬대상, "UInt", aOffsets*)
				sleep,10
				임시이름 := 타겟스킬이름 . "사용횟수"
				; 동적 변수 이름 사용
				GuiControlGet, 현재값,, %임시이름%
				임시횟수 := 현재값 + 1
				GuiControl,, %임시이름%, %임시횟수%
				RunMemory("타겟스킬사용")
			}
			return

		}

		마법사용(마법이름, 대상)
		{
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
			임시이름 := 마법이름 . "번호"
			GuiControlGet, 마법번호,, %임시이름%
			if (마법번호 != 0 && 마법대상!= 0)
			{
				WriteExecutableMemory("마법호출")
				mem.write(0x0059023A, 마법번호, "Char", aOffsets*)
				mem.write(0x0059023B, 마법대상, "UInt", aOffsets*)
				sleep,10
				RunMemory("마법사용")
				임시이름 := 마법이름 . "사용횟수"
				; 동적 변수 이름 사용
				GuiControlGet, 현재값,, %임시이름%
				임시횟수 := 현재값 + 1
				GuiControl,, %임시이름%, %임시횟수%
			}
			SetFormat, Integer, D
			return
		}

	;}

	;{ ; 설정 저장 및 불러오기 함수
		Downloaded_OID_RECORD(type,itemname*) ; 캐릭별 ListView 값을 (별도) 폴더에 저장하기
		{
			저장할맵번호 := itemname[4]
			FileName := "NPCList.ini"
			IniRead, allitems, %FileName%, %저장할맵번호%

			; 데이터가 없다면 새로운 데이터를 추가합니다.
			itemList := StrSplit(allitems, "`n") ; 줄 바꿈으로 분리하여 배열에 저장합니다.
			totalCount := itemList.MaxIndex()

			found := False
			Last := 0
			IniRead, line, data, %저장할맵번호%, 1
			; 각 이름에 대한 데이터를 확인합니다.
			for index, coord in itemList
			{
				Last := A_Index
				IniRead, existingData, %FileName%, %저장할맵번호%, %A_index%
				; 데이터를 쉼표로 분리하여 각 필드를 얻습니다
				fields := StrSplit(existingData, ",")

				if (fields[4] = itemname[4] && fields[5] = itemname[5] && fields[2] = itemname[2])
				{
					if(fields[6] = itemname[6])
					{
						found := True
						break
					}
					else (fields[6] != itemname[6])
					{
						gosub, 서버점검후OID변경감지
						Last := 0
						break
					}
				}
			}
			; 일치하는 데이터가 없다면 새로운 데이터를 추가합니다.
			Last += 1
			if (!found)
			{

				i := 1
				for index, item in itemname
				{
					if (i > 1)
					newDataRow .= ","
					i++
					newDataRow .= item
				}
				IniWrite, %newDataRow%, %FileName%, %저장할맵번호%, %Last%
			}
			return
			; INI 파일에서 해당 이름의 데이터를 읽어옵니다.
		}

		Setting_RECORD(type,itemname*) ; 캐릭별 ListView 값을 (별도) 폴더에 저장하기
		{
			FileDirectory := a_scriptdir . "\SaveOf" . TargetTitle
			if (TargetTitle = "" || TargetTitle = "일랜시아 - 엘" || TargetTitle = "일랜시아 - 테스")
			{
				return
			}
			else if !FileExist(FileDirectory)
			{
				temp_foldername := "SaveOf" . TargetTitle
				FileCreateDir, %temp_foldername%
			}
			맵번호 := mem.read(0x0058EB1C, "UInt", 0x10E)
			gui,submit,nohide
			if (type = "NPC리스트")
			{
				저장할맵번호 := itemname[4]
				FileName := "NPCList.ini"
				IniRead, allitems, %FileName%, %저장할맵번호%
			}
			else if (type = "고용상인리스트")
			{
				저장할맵번호 := itemname[4]
				FileName := "SellerList.ini"
				IniRead, allitems, %FileName%, %저장할맵번호%
			}
			else if (type = "좌표리스트")
			{
				FileName := "DB_DATA_Coord.ini"
				IniRead, allitems, %FileName%, %맵번호%
			}
			else if (type = "NEWDB")
			{
				저장할맵번호 := itemname[4]
				FileName := "NEWDB.ini"
				IniRead, allitems, %FileName%, %저장할맵번호%
			}
			else if (type = "MonsterList")
			{
				저장할맵번호 := itemname[4]
				FileName := "MonsterList.ini"
				IniRead, allitems, %FileName%, %저장할맵번호%
			}
			else
			{
				FileName := FileDirectory . "\Char_Setting.ini"
				IniRead, allitems, %FileName%, %type%
			}

			; 데이터가 없다면 새로운 데이터를 추가합니다.
			itemList := StrSplit(allitems, "`n") ; 줄 바꿈으로 분리하여 배열에 저장합니다.

			totalCount := itemList.MaxIndex()

			found := False
			Last := 0
			; 각 이름에 대한 데이터를 확인합니다.
			for index, existingData in itemList
			{
				Last := A_Index
				if (type = "좌표리스트")
				{
					IniRead, existingData, %FileName%,  %맵번호%, %A_index%
				}
				else if (type = "NEWDB" || type = "MonsterList" || tpye = "NPC리스트")
				{
					IniRead, existingData, %FileName%, %저장할맵번호%, %A_index%
				}
				else
				{
					IniRead, existingData, %FileName%, %type%, %A_index%
				}
				*/
				; 데이터를 쉼표로 분리하여 각 필드를 얻습니다.
				fields := StrSplit(existingData, ",")

				if (type = "좌표리스트" && fields[4] = itemname[1] && fields[5] = itemname[2] && fields[6] = itemname[3])
				{
					found := True
					break
				}
				else if (type = "NEWDB" && fields[4] = itemname[4] && fields[5] = itemname[5] && fields[12] = itemname[12])
				{
					found := True
					break
				} ; X, Y, Z 값이 일치하는지 확인합니다.
				else if (type = "MonsterList" && fields[1] = itemname[5] && fields[2] = itemname[12])
				{
					found := True
					break
				}
				else if (fields[1] = itemname[1] && type != "고용상인리스트" && type != "NPC리스트" && type != "NEWDB" && type != "MonsterList")
				{
					found := True
					break
				}
				else if (fields[4] = itemname[4] && fields[5] = itemname[5] && fields[2] = itemname[2] && type = "NPC리스트")
				{
					if (fields[6] = itemname[6])
					{
						found := True
						break
					}
					else if (fields[6] != itemname[6])
					{
						gosub, 서버점검후OID변경감지
						found := False
						Last := 0
						break
					}
				}
				else if (fields[4] = itemname[4] && fields[5] = itemname[5] && fields[2] = itemname[2] && type = "고용상인리스트")
				{
					if (fields[6] = itemname[6])
					{
						found := True
						break
					}
					else if (fields[6] != itemname[6])
					{
						gosub, 서버점검후OID변경감지
						found := False
						Last := 0
						break
					}
				}
			}
			; 일치하는 데이터가 없다면 새로운 데이터를 추가합니다.
			Last += 1
			if (!found)
			{
				SB_SetText(type "의" Last "줄에"  itemname[5] "추가",2)
				if (type = "좌표리스트")
				{
					; 새로운 데이터를 하나의 문자열로 만듭니다.
					newDataRow := 맵번호 . "," . Last . "," . 맵이름 . "," . itemname[1] . "," . itemname[2] . "," . itemname[3]

					; 데이터를 INI 파일에 씁니다.
					IniWrite, %newDataRow%, %FileName%, %맵번호%, %Last%
				}
				else if (type = "MonsterList")
				{
					; 새로운 데이터를 하나의 문자열로 만듭니다.
					newDataRow := itemname[5] . "," . itemname[12]

					; 데이터를 INI 파일에 씁니다.
					IniWrite, %newDataRow%, %FileName%, %저장할맵번호%, %Last%
				}
				else if (type = "NPC리스트")
				{
					i := 1
					for index, item in itemname
					{
						if (i > 1)
						newDataRow .= ","
						i++
						newDataRow .= item
					}
					URL:="https://script.google.com/macros/s/AKfycby1xjtGctTjzYk_u2hJO67iGbyM-qUnpnL-OgJ383wod5MeqX7jRtGmnkPX5o9ihZjejw/exec"
					URL := URL . "?Kind=" . itemname[1] . "&Dimension=" . itemname[2] . "&MapName=" . itemname[3] . "&MapNumber=" . itemname[4] . "&Name=" . itemname[5] . "&OID=" . itemname[6] . "&X=" . itemname[7] . "&Y=" . itemname[8] . "&Z=" . itemname[9] . "&IMG=" . itemname[12] . "&Reporter=" . TargetTitle
					uJoin(URL)
					IniWrite, %newDataRow%, %FileName%, %저장할맵번호%, %Last%
				}
				else if (type = "고용상인리스트")
				{
					i := 1
					for index, item in itemname
					{
						if (i > 1)
						newDataRow .= ","
						i++
						newDataRow .= item
					}
					IniWrite, %newDataRow%, %FileName%, %저장할맵번호%, %Last%
				}
				else if (type = "NEWDB")
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
					IniWrite, %newDataRow%, %FileName%, %저장할맵번호%, %Last%
				}
				else
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
			}
			return
			; INI 파일에서 해당 이름의 데이터를 읽어옵니다.
		}

		Setting_DELETE(type,itemname*)  ; 선택된 ListView 값을 삭제하기
		{
			gosub, 기본정보읽기
			gui,submit,nohide

			if (type = "NPC리스트")
			{
				FileName := "NPCList.ini"
				IniRead, allitems, %FileName%, %맵번호%
			}
			else if (type = "좌표리스트")  ; 좌표리스트의 경우 공용으로 저장파일을 사용
			{
				FileName := "DB_DATA_Coord.ini"
				subject := itemname[1]
				IniRead, allitems, %FileName%, %subject%
			}
			else
			{
				FileName := a_scriptdir . "\SaveOf" . TargetTitle . "\Char_Setting.ini"
				IniRead, allitems, %FileName%, %type%
			}

			itemList := StrSplit(allitems, "`n")
			newItems := {} ; 새로운 아이템을 저장할 배열

			found := False

			for index, item in itemList
			{
				if (type = "좌표리스트")
				{
					IniRead, existingData, %FileName%, %subject%, %A_index%
				}
				else if (type = "NPC리스트")
				{
					IniRead, existingData, %FileName%, %맵번호%, %A_index%
				}
				else
				{
					IniRead, existingData, %FileName%, %type%, %A_index%
				}

				fields := StrSplit(existingData, ",")
				if (type = "좌표리스트") && (fields[4] = itemname[3] && fields[5] = itemname[4] && fields[6] = itemname[5])
				{
					found := true
					; 삭제 대상이므로 스킵합니다.
				}
				else if (fields[1] = itemname[1] && type != "NPC리스트" && type != "좌표리스트") || (fields[2] = itemname[2] && fields[5] = itemname[5] && fields[6] = itemname[6] && type = "NPC리스트")
				{
					found := true
					; 삭제 대상이므로 스킵합니다.
				}
				else
				{
					; 삭제 대상이 아니므로 새 배열에 추가합니다.
					newItems.Push(existingData)
				}
			}

			index := 1

			; 기존의 모든 행을 삭제합니다.
			if (type = "좌표리스트")
			{
				IniDelete, %FileName%, %subject%
				for index, item in newItems
				{
					; 새로운 아이템을 다시 씁니다.
					IniWrite, %item%, %FileName%, %subject%, %index%
					index++
				}
			}
			else if (type = "NPC리스트")
			{
				IniDelete, %FileName%, %맵번호%
				for index, item in newItems
				{
					; 새로운 아이템을 다시 씁니다.
					IniWrite, %item%, %FileName%, %맵번호%, %index%
					index++
				}
			}
			else
			{
				IniDelete, %FileName%, %type%
				for index, item in newItems
				{
					; 새로운 아이템을 다시 씁니다.
					IniWrite, %item%, %FileName%, %type%, %index%
					index++
				}
			}
			return
		}

		Setting_Reload(type) ; 캐릭별 ListView 값을 (별도의) 폴더에서 불러오기
		{
			/*
			; - ListView 항목 -
			;	NPC리스트
			;	원하는아이템리스트
			;	은행넣을아이템리스트
			;	소각할아이템리스트
			;	원하는몬스터리스트
			;	좌표리스트
			*/

			if (type = "NPC리스트") ; NPCList의 경우 공용으로 저장파일을 사용
			{
				FileName := "NPCList.ini"
				IniRead, allitems, %FileName%, %맵번호%
			}
			else if (type = "고용상인리스트") ; NPCList의 경우 공용으로 저장파일을 사용
			{
				FileName := "SellerList.ini"
				IniRead, allitems, %FileName%, %맵번호%
			}
			else if (type = "좌표리스트")  ; 좌표리스트의 경우 공용으로 저장파일을 사용
			{
				gosub, 기본정보읽기
				gui,submit,nohide
				FileName := "DB_DATA_Coord.ini"
				IniRead, allitems, %FileName%, %맵번호%
			}
			else
			{
				FileName := a_scriptdir . "\SaveOf" . TargetTitle . "\Char_Setting.ini"  ; 그 외의 경우 별도 폴더에 저장파일을 사용
				IniRead, allitems, %FileName%, %type%
			}

			itemList := StrSplit(allitems, "`n")

			for index, item in itemList
			{
				if (type = "좌표리스트" || type = "NPC리스트" || type = "고용상인리스트" )
				{
					IniRead, existingData, %FileName%, %맵번호%, %A_index%
				}
				else
				{
					IniRead, existingData, %FileName%, %type%, %A_index%
				}
				fields := StrSplit(existingData, ",")
				if (type = "좌표리스트")
				{
					fields[2] := A_index
					gui,listview,좌표리스트
				}
				gui,listview,%type%
				LV_Add("", fields*)
			}
			return
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
			return
		}

		DB_RECORD(kind,newMapNumber,newMapName,newName,newImageNumber,newX := 0,newY := 0,newZ := 0) 	;인게임 DB수집용 함수; 공개할때는 없애야 하는 함수
		{
			if (kind = "고용상인")
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
			return
		}

		WriteLOG(Error) ;개발 디버그용 함수; 공개할때는 없애야 하는 함수
		{
			저장위치 := a_scriptdir . "\SaveOf" . TargetTitle . "\ErrorLog.ini"
			지금시각 = %A_Now%
			FormatTime, 지금시각_R, %지금시각%, yyyyMMdd
			FormatTime, 지금시각_T, %지금시각%, HHmmss
			newDataRow := Error  ; 시간=ERROR 형식으로 변경

			; 데이터를 INI 파일에 씁니다.
			IniWrite, %newDataRow%, %저장위치%, %지금시각_R%, %지금시각_T%
			return
		}
	;}

;}

;-------------------------------------------------------
;-------단발성 실행 코드---------------------------------
;-------------------------------------------------------
;{

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

리노아호출입장()
{
	sleep, 1000
	맵번호 := mem.read(0x0058EB1C, "UInt", 0x10E)
	if (맵번호 != 4002)
	{
		return 0
	}
	NPCMsg := mem.readString(NPC_MSG_ADR, 52, "UTF-16", aOffsets*)
	FormNumber := mem.read(0x0058DAD0, "UInt", 0xC, 0x10, 0x8, 0xA0)

	gosub, 기본정보읽기
	gui,submit,nohide

	if(FormNumber = 85)
	{
		MouseClick(379,323)
	}
	sleep, 1000
	if ((NPC_MSG_ADR = "없음") || (NPC_MSG_ADR < 1))
	{
		sleep, 500
		SetFormat, Integer, H
		startAddress := 0x00100000
		endAddress := 0x00200000
		NPC_MSG_ADR := mem.processPatternScan(startAddress, endAddress, 0x31, 0x00, 0x30, 0x00, 0x30, 0x00, 0x30, 0x00, 0x30, 0x00, 0x08, 0xAC, 0xAC, 0xB9, 0xDC, 0xB4, 0x7C, 0xB9, 0x20) ; "10000갈리드를" 검색
		SetFormat, Integer, D
		SB_SetText("NPC대화주소검색중" NPC_MSG_ADR,2)
		GuiControl,, NPC_MSG_ADR, %NPC_MSG_ADR%
		sleep, 100
	}

	if ((NPC_MSG_ADR = "없음") || (NPC_MSG_ADR < 1))
		return 0
	else
	{
		NPCMsg := mem.readString(NPC_MSG_ADR, 52, "UTF-16", aOffsets*)
		if(instr(NPCMsg,"10000갈리드"))
		{
			mem.writeString(NPC_MSG_ADR, "", "UTF-16", aOffsets*)
			temp:=get_NPCTalk_cordi()
			x:=temp.x - 44
			y:=temp.y + 10
			MouseClick(x,y)
		}
		else
		{
			SB_SetText("갈리드부족의심",2)
			return 0
		}
		sleep, 1000
		NPCMsg := mem.readString(NPC_MSG_ADR, 52, "UTF-16", aOffsets*)
		if(instr(NPCMsg,"잘 받았어"))
		{
			mem.writeString(NPC_MSG_ADR, "", "UTF-16", aOffsets*)
			keyclick("K6")
			sleep, 1000
			맵번호 := mem.read(0x0058EB1C, "UInt", 0x10E)
			if (맵번호 = 4005)
			{
				NPC대화창사용중 := False
				return 1
			}
			else
			{
				NPC대화창사용중 := False
				return 0
			}
		}
		else
		{
			NPC대화창사용중 := False
			return 0
		}
	}
return 0
}

라깃구매강제:
라깃구매필요 := true

라깃구매:
;{
	목적마을 := "포프레스네"
	목적지 := "마법상점"
	동작방법 := "Buy"
	gosub, 포프레스네상점이동세팅
	settimer, 스킬사용하기, off
	loop,
	{
		sleep, 1000
		;if (CurrentMode = "대기모드")
		;	continue

		맵번호 := mem.read(0x0058EB1C, "UInt", 0x10E)
		맵이름 := mem.readString(mem.getModuleBaseAddress("jelancia_core.dll")+0x44A28, 50, "UTF-16", 0xC)
		Gui, ListView, NPC리스트
		LV_Delete()
		Setting_Reload("NPC리스트")
		좌표X := mem.read(0x0058DAD4, "UInt", 0x10)
		좌표Y := mem.read(0x0058DAD4, "UInt", 0x14)
		좌표Z := mem.read(0x0058DAD4, "UInt", 0x18)
		IsMoving := mem.read(0x0058EB1C, "UInt", 0x174)
		SB_SetText(목적마을 목적지 " 가는중",2)
		if (맵번호 = 목적지맵번호)
		{
			InStep := 2
		}
		else if (맵번호 = 목적마을맵번호)
		{
			InStep := 1
		}
		else if (IsDataInList(맵번호, 나가기가능맵)) ;마을의 베이커리 ; 마법상점 ; 안이라면
		{
			gosub, 상점나가기
			continue
		}
		else
		{
			Dimension := mem.read(0x0058EB1C, "UInt", 0x10A)
			if(Dimension>20000)
				차원:="감마"
			else if(Dimension>10000)
				차원:="베타"
			else if(Dimension<10000)
				차원:="알파"
			sleep, 1
			목적차원 := 차원
			라깃사용하기(목적마을,목적차원)
			sleep, 100
			continue
		}


		if ( InStep = 1 )
		{
			if (isMoving = 0)
			{
				좌표입력(목적지X,목적지Y,목적지Z)
				sleep, 1
				RunMemory("좌표이동")
			}
			continue
		}
		else if ( InStep = 2 )
		{
			if (isMoving = 0)
			{
				if ( CallNPC(NPC이름) = 1)
					break
				좌표입력(NPC대화가능X,NPC대화가능Y,NPC대화가능Z)
				sleep, 1
				RunMemory("좌표이동")
			}
			continue
		}
	}
	sleep, 1000
	loop,
	{
		SB_SetText(NPC이름 " 근처에 가는중",2)
		loop, 5
		{
			CheatEngine_Move_Buy()
			NpcMenuSelection := mem.read(0x0058F0A4, "UInt", aOffset*) ; 메뉴창이 잘 떳는지 확인
			if (NpcMenuSelection = 0)
			{
				SB_SetText("NPC호출실패 다시호출",2)
				CallNPC(NPC이름)
			}
			else
			{
				SB_SetText("NPC호출성공",2)
				break
			}
			sleep, 100
		}

		loop, 5
		{
			NPCMENUSELECT(동작방법)
			sleep, 100
			if (Check_Shop(동작방법)!=0)
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
			target := NPC이름 . A_Index
			target := %target%
			if (target = "오란의깃")
			{
				count := 100 - 아이템갯수["오란의깃"]
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
				count := 20 - 아이템갯수["라스의깃"]
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
		loop, 1
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
		gosub, 아이템읽어오기

		if (아이템갯수["라스의깃"] >= 20) ||  (아이템갯수["오란의깃"] >= 100)
		{
			거래창사용중 := False
			라깃구매필요 := False
			break
		}
	}

	guicontrol, ,라깃구매필요상태,%라깃구매필요%
	settimer, 스킬사용하기, 1000
	sleep, 500
	gosub, 상점나가기

return
;}

배달라깃구매:
;{
	라깃구매목적지 := "마법상점"
	동작방법 := "Buy"
	gosub, 배달상점이동세팅
	settimer, 스킬사용하기, off
	loop,
	{
		sleep, 1000
		;if (CurrentMode = "대기모드")
		;	continue

		맵번호 := mem.read(0x0058EB1C, "UInt", 0x10E)
		맵이름 := mem.readString(mem.getModuleBaseAddress("jelancia_core.dll")+0x44A28, 50, "UTF-16", 0xC)
		Gui, ListView, NPC리스트
		LV_Delete()
		Setting_Reload("NPC리스트")
		좌표X := mem.read(0x0058DAD4, "UInt", 0x10)
		좌표Y := mem.read(0x0058DAD4, "UInt", 0x14)
		좌표Z := mem.read(0x0058DAD4, "UInt", 0x18)
		IsMoving := mem.read(0x0058EB1C, "UInt", 0x174)
		SB_SetText(목적마을 라깃구매목적지 " 가는중",2)
		if (맵번호 = 목적지맵번호)
		{
			InStep := 2
		}
		else if (맵번호 = 목적마을맵번호)
		{
			InStep := 1
		}
		else if (IsDataInList(맵번호, 나가기가능맵)) ;마을의 베이커리 ; 마법상점 ; 안이라면
		{
			gosub, 상점나가기
			continue
		}
		else
		{
			Dimension := mem.read(0x0058EB1C, "UInt", 0x10A)
			if(Dimension>20000)
				차원:="감마"
			else if(Dimension>10000)
				차원:="베타"
			else if(Dimension<10000)
				차원:="알파"
			sleep, 1
			목적차원 := 차원
			라깃사용하기(목적마을,목적차원)
			sleep, 100
			continue
		}


		if ( InStep = 1 )
		{
			if (isMoving = 0)
			{
				좌표입력(목적지X,목적지Y,목적지Z)
				sleep, 1
				RunMemory("좌표이동")
			}
			continue
		}
		else if ( InStep = 2 )
		{
			if (isMoving = 0)
			{
				if ( CallNPC(NPC이름) = 1)
					break
				좌표입력(NPC대화가능X,NPC대화가능Y,NPC대화가능Z)
				sleep, 1
				RunMemory("좌표이동")
			}
			continue
		}
	}
	sleep, 1000
	loop,
	{
		SB_SetText(NPC이름 " 근처에 가는중",2)
		loop, 5
		{
			NpcMenuSelection := mem.read(0x0058F0A4, "UInt", aOffset*) ; 메뉴창이 잘 떳는지 확인
			if (NpcMenuSelection = 0)
			{
				SB_SetText("NPC호출실패 다시호출",2)
				CallNPC(NPC이름)
			}
			else
			{
				SB_SetText("NPC호출성공",2)
				break
			}
			sleep, 100
		}

		loop, 5
		{
			NPCMENUSELECT(동작방법)
			sleep, 100
			if (Check_Shop(동작방법)!=0)
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
			target := NPC이름 . A_Index
			target := %target%
			if (target = "오란의깃")
			{
				count := 100 - 아이템갯수["오란의깃"]
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
				count := 100 ;- 아이템갯수["라스의깃"]
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
		loop, 5
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
		gosub, 아이템읽어오기

		if (아이템갯수["라스의깃"] >= 200) ||  (아이템갯수["오란의깃"] >= 100)
		{
			거래창사용중 := False
			라깃구매필요 := False
			break
		}
	}

	guicontrol, ,라깃구매필요상태,%라깃구매필요%
	settimer, 스킬사용하기, 1000
	sleep, 500
	gosub, 상점나가기

return
;}

식빵구매강제:
식빵구매필요 := true

식빵구매:
;{
	목적마을 := "포프레스네"
	목적지 := "베이커리"
	동작방법 := "Buy"
	gosub, 포프레스네상점이동세팅
	settimer, 스킬사용하기, off
	loop,
	{
		sleep, 1000
		;if (CurrentMode = "대기모드")
		;	continue

		맵번호 := mem.read(0x0058EB1C, "UInt", 0x10E)
		맵이름 := mem.readString(mem.getModuleBaseAddress("jelancia_core.dll")+0x44A28, 50, "UTF-16", 0xC)
		Gui, ListView, NPC리스트
		LV_Delete()
		Setting_Reload("NPC리스트")
		좌표X := mem.read(0x0058DAD4, "UInt", 0x10)
		좌표Y := mem.read(0x0058DAD4, "UInt", 0x14)
		좌표Z := mem.read(0x0058DAD4, "UInt", 0x18)
		IsMoving := mem.read(0x0058EB1C, "UInt", 0x174)
		SB_SetText(목적마을 목적지 " 가는중",2)
		if (맵번호 = 목적지맵번호)
		{
			InStep := 2
		}
		else if (맵번호 = 목적마을맵번호)
		{
			InStep := 1
		}
		else if (IsDataInList(맵번호, 나가기가능맵)) ;마을의 베이커리 ; 마법상점 ; 안이라면
		{
			gosub, 상점나가기
			continue
		}
		else
		{
			Dimension := mem.read(0x0058EB1C, "UInt", 0x10A)
			if(Dimension>20000)
				차원:="감마"
			else if(Dimension>10000)
				차원:="베타"
			else if(Dimension<10000)
				차원:="알파"
			sleep, 1
			목적차원 := 차원
			라깃사용하기(목적마을,목적차원)
			sleep, 100
			continue
		}

		if ( InStep = 1 )
		{
			if (isMoving = 0)
			{
				좌표입력(목적지X,목적지Y,목적지Z)
				sleep, 1
				RunMemory("좌표이동")
			}
			continue
		}
		else if ( InStep = 2 )
		{
			if (isMoving = 0)
			{
				if ( CallNPC(NPC이름) = 1)
					break
				좌표입력(NPC대화가능X,NPC대화가능Y,NPC대화가능Z)
				sleep, 1
				RunMemory("좌표이동")
			}
			continue
		}
	}
	sleep, 1000
	loop,
	{
		SB_SetText(NPC이름 " 근처에 가는중",2)
		loop, 5
		{
			CheatEngine_Move_Buy()
			NpcMenuSelection := mem.read(0x0058F0A4, "UInt", aOffset*) ; 메뉴창이 잘 떳는지 확인
			if (NpcMenuSelection = 0)
			{
				SB_SetText("NPC호출실패 다시호출",2)
				CallNPC(NPC이름)
			}
			else
			{
				SB_SetText("NPC호출성공",2)
				break
			}
			sleep, 100
		}

		loop, 5
		{
			NPCMENUSELECT(동작방법)
			sleep, 100
			if (Check_Shop(동작방법)!=0)
				break
		}

		NPC거래창첫번째메뉴클릭()
		쿠키28 := "식빵"
		loop, 29
		{
			target := NPC이름 . A_Index
			target := %target%
			if (target = "식빵")
			{
				keyclick("K1")
				keyclick("K0")
				keyclick("K0")
				break
			}
			keyclick("DownArrow")
		}
		loop, 30
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
		gosub, 아이템읽어오기

		if (아이템갯수["식빵"] >= 181)
		{
			break
		}
	}
	거래창사용중 := False
	식빵구매필요 := False
	guicontrol, ,식빵구매필요상태,%식빵구매필요%
	settimer, 스킬사용하기, 1000
	sleep, 500
	gosub, 상점나가기

return
;}

배달상점이동세팅:
;{
	if (목적마을 = "로랜시아")
	{
		목적마을맵번호 := 2
		if (라깃구매목적지 = "마법상점" && 라깃구매필요)
		{
			목적지맵번호 := 219
			NPC이름 := "에레노아" ;
			목적지X := 201
			목적지Y := 119
			목적지Z := 1
			NPC대화가능X := 54
			NPC대화가능Y := 27
			NPC대화가능Z := 0
		}
		else if (목적지 = "목공소")
		{
			목적지맵번호 := 208
			NPC이름 := "라드"
			목적지X := 193
			목적지Y := 175
			목적지Z := 2
			NPC대화가능X := 30
			NPC대화가능Y := 25
			NPC대화가능Z := 0
		}
		else if (목적지 = "퍼브")
		{
			목적지맵번호 := 214
			NPC이름 := "네루아" ;
			목적지X := 230
			목적지Y := 100
			목적지Z := 2
			NPC대화가능X := 46
			NPC대화가능Y := 33
			NPC대화가능Z := 1
		}
		else if (목적지 = "우체국")
		{
			목적지맵번호 := 217
			NPC이름 := "큐트" ;
			목적지X := 224
			목적지Y := 79
			목적지Z := 2
			NPC대화가능X := 25
			NPC대화가능Y := 18
			NPC대화가능Z := 0
		}
		else if (목적지 = "신전")
		{
			목적지맵번호 := 229
			NPC이름 := "기도"
			목적지X := 213
			목적지Y := 56
			목적지Z := 1
			NPC대화가능X := 38
			NPC대화가능Y := 30
			NPC대화가능Z := 0
		}
	}
	else if (목적마을 = "에필로리아")
	{
		목적마을맵번호 := 1002
		if (라깃구매목적지 = "마법상점" && 라깃구매필요)
		{
			목적지맵번호 := 1219
			NPC이름 := "카로에" ;
			목적지X := 102
			목적지Y := 90
			목적지Z := 1
			NPC대화가능X := 23
			NPC대화가능Y := 11
			NPC대화가능Z := 0
		}
		else if (목적지 = "신전")
		{
			목적지맵번호 := 1229
			NPC이름 := "기도"
			목적지X := 88
			목적지Y := 148
			목적지Z := 0
			NPC대화가능X := 55
			NPC대화가능Y := 45
			NPC대화가능Z := 0
		}
		else if (목적지 = "목공소")
		{
			목적지맵번호 := 1208
			NPC이름 := "하즈"
			목적지X := 115
			목적지Y := 122
			목적지Z := 0
			NPC대화가능X := 12
			NPC대화가능Y := 22
			NPC대화가능Z := 0
		}
		else if (목적지 = "퍼브")
		{
			목적지맵번호 := 1214
			NPC이름 := "샤네트"
			목적지X := 88
			목적지Y := 28
			목적지Z := 1
			NPC대화가능X := 27
			NPC대화가능Y := 16
			NPC대화가능Z := 0
		}
		else if (목적지 = "우체국") ;쿠키용
		{
			목적지맵번호 := 1217
			NPC이름 := "호다니" ;
			목적지X := 121
			목적지Y := 42
			목적지Z := 0
			NPC대화가능X := 17
			NPC대화가능Y := 27
			NPC대화가능Z := 0
		}

	}
	else if (목적마을 = "세르니카")
	{
		목적마을맵번호 := 2002
		if (라깃구매목적지 = "마법상점" && 라깃구매필요)
		{
			목적지맵번호 := 2219
			NPC이름 := "백작" ;
			목적지X := 73
			목적지Y := 64
			목적지Z := 0
			NPC대화가능X := 46
			NPC대화가능Y := 41
			NPC대화가능Z := 0
		}
		else if (목적지 = "신전")
		{
			목적지맵번호 := 2229
			NPC이름 := "기도"
			목적지X := 99
			목적지Y := 75
			목적지Z := 0
			NPC대화가능X := 21
			NPC대화가능Y := 15
			NPC대화가능Z := 1
		}
		else if (목적지 = "목공소")
		{
			목적지맵번호 := 2208
			NPC이름 := "우트" ;골드바 판매, 구매용
			목적지X := 179
			목적지Y := 107
			목적지Z := 0
			NPC대화가능X := 22
			NPC대화가능Y := 18
			NPC대화가능Z := 0
		}
		else if (목적지 = "퍼브")
		{
			목적지맵번호 := 2214
			NPC이름 := "카르고" ; 무기수리용
			목적지X := 137
			목적지Y := 126
			목적지Z := 0
			NPC대화가능X := 27
			NPC대화가능Y := 34
			NPC대화가능Z := 1
		}
		else if (목적지 = "우체국") ;쿠키용
		{
			목적지맵번호 := 2217
			NPC이름 := "티모시" ;
			목적지X := 66
			목적지Y := 76
			목적지Z := 0
			NPC대화가능X := 26
			NPC대화가능Y := 22
			NPC대화가능Z := 0
		}

	}
	else if (목적마을 = "크로노시스")
	{
		목적마을맵번호 := 3002
		if (목적지 = "신전")
		{
			목적지맵번호 := 3229
			NPC이름 := "기도"
			목적지X := 150
			목적지Y := 61
			목적지Z := 0
			NPC대화가능X := 36
			NPC대화가능Y := 17
			NPC대화가능Z := 0
		}
	}
	else if (목적마을 = "포프레스네")
	{
		목적마을맵번호 := 4002
		if (목적지 = "신전")
		{
			목적지맵번호 := 4229
			NPC이름 := "기도"
			목적지X := 103
			목적지Y := 42
			목적지Z := 1
			NPC대화가능X := 33
			NPC대화가능Y := 33
			NPC대화가능Z := 0
		}
	}
return
;}

상점나가기:
;{
	loop,
	{
		sleep, 1000
		맵번호 := mem.read(0x0058EB1C, "UInt", 0x10E)
		sleep, 1
		맵이름 := mem.readString(mem.getModuleBaseAddress("jelancia_core.dll")+0x44A28, 50, "UTF-16", 0xC)

		좌표X := mem.read(0x0058DAD4, "UInt", 0x10)
		좌표Y := mem.read(0x0058DAD4, "UInt", 0x14)
		좌표Z := mem.read(0x0058DAD4, "UInt", 0x18)
		IsMoving := mem.read(0x0058EB1C, "UInt", 0x174)
		;로랜시아
		if (맵번호 = 4207 || 맵번호 = 4209 || 맵번호 = 4215 || 맵번호 = 4219)
		{
			목적지퇴장X := 34
			목적지퇴장Y := 34
			목적지퇴장Z := 0
		}
		else if (맵번호 = 4200 || 맵번호 = 4211 || 맵번호 = 4213 || 맵번호 = 4216)
		{
			목적지퇴장X := 32
			목적지퇴장Y := 31
			목적지퇴장Z := 0
		}
		else if (맵번호 = 4210)
		{
			목적지퇴장X := 44
			목적지퇴장Y := 38
			목적지퇴장Z := 0
		}
		else if( 맵번호 = 4002 && 좌표X >=71 && 좌표X <=73 && 좌표Y == 62)
		{
			좌표입력(76,66,1)
			sleep,10
			RunMemory("좌표이동")
		}
		else if (맵번호 = 208)
		{
			목적지퇴장X := 25
			목적지퇴장Y := 42
			목적지퇴장Z := 0
		}
		else if (맵번호 = 214)
		{
			목적지퇴장X := 47
			목적지퇴장Y := 52
			목적지퇴장Z := 1
		}
		else if (맵번호 = 217)
		{
			목적지퇴장X := 25
			목적지퇴장Y := 19
			목적지퇴장Z := 0
		}
		else if (맵번호 = 219)
		{
			목적지퇴장X := 54
			목적지퇴장Y := 43
			목적지퇴장Z := 0
		}
		else if (맵번호 = 1219)
		{
			목적지퇴장X := 17
			목적지퇴장Y := 17
			목적지퇴장Z := 0
		}
		else if (맵번호 = 2219)
		{
			목적지퇴장X := 46
			목적지퇴장Y := 44
			목적지퇴장Z := 0
		}
		else if (맵번호 = 1208)
		{
			목적지퇴장X := 12
			목적지퇴장Y := 23
			목적지퇴장Z := 0
		}
		else if (맵번호 = 1214)
		{
			목적지퇴장X := 20
			목적지퇴장Y := 29
			목적지퇴장Z := 0
		}
		else if (맵번호 = 1217)
		{
			목적지퇴장X := 17
			목적지퇴장Y := 28
			목적지퇴장Z := 0
		}
		else if (맵번호 = 2208)
		{
			목적지퇴장X := 24
			목적지퇴장Y := 48
			목적지퇴장Z := 0
		}
		else if (맵번호 = 2214)
		{
			목적지퇴장X := 49
			목적지퇴장Y := 62
			목적지퇴장Z := 0
		}
		else if (맵번호 = 2217)
		{
			목적지퇴장X := 27
			목적지퇴장Y := 25
			목적지퇴장Z := 0
		}
		else if (맵번호 = 229)
		{
			목적지퇴장X := 40
			목적지퇴장Y := 76
			목적지퇴장Z := 0
		}
		else if (맵번호 = 1229)
		{
			목적지퇴장X := 47
			목적지퇴장Y := 8
			목적지퇴장Z := 0
		}
		else if (맵번호 = 2229)
		{
			목적지퇴장X := 19
			목적지퇴장Y := 58
			목적지퇴장Z := 1
		}
		else if (맵번호 = 3229)
		{
			목적지퇴장X := 36
			목적지퇴장Y := 56
			목적지퇴장Z := 0
		}
		else if (맵번호 = 4229)
		{
			목적지퇴장X := 34
			목적지퇴장Y := 34
			목적지퇴장Z := 0
		}
		else
		{
			break
		}
		if (isMoving = 0)
		{
			if (좌표X = 목적지퇴장X && 좌표Y = 목적지퇴장Y)
				keyclick("AltR")
			좌표입력(목적지퇴장X,목적지퇴장Y,목적지퇴장Z)
			sleep, 1
			RunMemory("좌표이동")
		}
	}
	return
;}

배달상점가기:
;{
;목적마을 :=
;목적지 :=
	gui,submit,nohide


	loop,
	{

		맵번호 := mem.read(0x0058EB1C, "UInt", 0x10E)
		맵이름 := mem.readString(mem.getModuleBaseAddress("jelancia_core.dll")+0x44A28, 50, "UTF-16", 0xC)
		Gui, ListView, NPC리스트
		LV_Delete()
		Setting_Reload("NPC리스트")
		좌표X := mem.read(0x0058DAD4, "UInt", 0x10)
		좌표Y := mem.read(0x0058DAD4, "UInt", 0x14)
		좌표Z := mem.read(0x0058DAD4, "UInt", 0x18)
		NPCX:=999
		NPCY:=999
		gui,listview,NPC리스트
		Loop % LV_GetCount()
		{
			LV_GetText(NPC차원,A_index,2)
			LV_GetText(호출할NPC,A_index,5)
			if (NPC차원 = 차원 && 호출할NPC = NPC이름 )
			{
				LV_GetText(NPCX,A_index,7)
				LV_GetText(NPCY,A_index,8)
				LV_GetText(NPCZ,A_index,9)
				break
			}
			else if (NPC차원 = 차원) && InStr(호출할NPC,NPC이름)
			{
				LV_GetText(NPCX,A_index,7)
				LV_GetText(NPCY,A_index,8)
				LV_GetText(NPCZ,A_index,9)
				break
			}
		}
		거리X := ABS(좌표X - NPCX)
		거리Y := ABS(좌표Y - NPCY)
		if((좌표X = NPC대화가능X && 좌표Y = NPC대화가능Y && 맵번호 = 목적지맵번호) || (거리X<16 && 거리Y<8) )
		{
			break
		}
		IsMoving := mem.read(0x0058EB1C, "UInt", 0x174)
		SB_SetText(목적마을 목적지 " 가는중",2)
		Dimension := mem.read(0x0058EB1C, "UInt", 0x10A)
		if(Dimension>20000)
			차원:="감마"
		else if(Dimension>10000)
			차원:="베타"
		else if(Dimension<10000)
			차원:="알파"
		if (맵번호 = 목적지맵번호)
		{
			InStep := 2
		}
		else if (맵번호 = 목적마을맵번호)
		{
			InStep := 1
		}
		else if (IsDataInList(맵번호, 나가기가능맵)) ;갈리드 아끼기 모드
		{
			gosub, 상점나가기
			continue
		}
		else
		{
			sleep, 1
			라깃사용하기(목적마을,차원)
			sleep, 100
			continue
		}
		if ( InStep = 1 )
		{
			if (isMoving = 0)
			{
				if (좌표X = 목적지X && 좌표Y = 목적지Y)
					KeyClick("AltR")
				좌표입력(목적지X,목적지Y,목적지Z)
				sleep, 1
				RunMemory("좌표이동")
				sleep,300
			}
			continue
		}
		else if ( InStep = 2 )
		{
			if (isMoving = 0)
			{
				if(좌표X = NPC대화가능X && 좌표Y = NPC대화가능Y)
					break
				좌표입력(NPC대화가능X,NPC대화가능Y,NPC대화가능Z)
				sleep, 1
				RunMemory("좌표이동")
				sleep,300
			}
			continue
		}
	}
return
;}

포프레스네상점이동세팅:
;{
	if (목적마을 = "포프레스네")
	{
		목적마을맵번호 := 4002
		if (목적지 = "은행")
		{
			목적지맵번호 := 4209
			NPC이름 := "드골" ;골드바 판매, 구매용
			목적지X := 78
			목적지Y := 138
			목적지Z := 1
			NPC대화가능X := 34
			NPC대화가능Y := 25
			NPC대화가능Z := 0
		}
		else if (목적지 = "무기상점")
		{
			목적지맵번호 := 4213
			NPC이름 := "키아" ; 무기수리용
			목적지X := 72
			목적지Y := 61
			목적지Z := 1
			NPC대화가능X := 32
			NPC대화가능Y := 30
			NPC대화가능Z := 0
		}
		else if (목적지 = "베이커리") ;쿠키용
		{
			목적지맵번호 := 4200
			NPC이름 := "쿠키" ;
			목적지X := 50
			목적지Y := 83
			목적지Z := 1
			NPC대화가능X := 33
			NPC대화가능Y := 30
			NPC대화가능Z := 0
		}
		else if (목적지 = "베이커리2") ;베스 용
		{
			목적지맵번호 := 4200
			NPC이름 := "베스" ;
			목적지X := 50
			목적지Y := 83
			목적지Z := 1
			NPC대화가능X := 32
			NPC대화가능Y := 21
			NPC대화가능Z := 0
		}
		else if (목적지 = "잡화점")
		{
			목적지맵번호 := 4216
			NPC이름 := "크로리스" ;
			목적지X := 74
			목적지Y := 99
			목적지Z := 1
			NPC대화가능X := 33
			NPC대화가능Y := 30
			NPC대화가능Z := 0
		}
		else if (목적지 = "보석상점")
		{
			목적지맵번호 := 4215
			NPC이름 := "포프리아" ;
			목적지X := 52
			목적지Y := 161
			목적지Z := 1
			NPC대화가능X := 38
			NPC대화가능Y := 22
			NPC대화가능Z := 0
		}
		else if (목적지 = "무기상점")
		{
			목적지맵번호 := 4213
			NPC이름 := "키아"
			목적지X := 94
			목적지Y := 162
			목적지Z := 1
			NPC대화가능X := 32
			NPC대화가능Y := 30
			NPC대화가능Z := 0
		}
		else if (목적지 = "병원")
		{
			목적지맵번호 := 4211
			NPC이름 := "소피"
			목적지X := 135
			목적지Y := 155
			목적지Z := 1
			NPC대화가능X := 31
			NPC대화가능Y := 29
			NPC대화가능Z := 0
		}
		else if (목적지 = "의류상점")
		{
			목적지맵번호 := 4207
			NPC이름 := "포비"
			목적지X := 158
			목적지Y := 145
			목적지Z := 1
			NPC대화가능X := 35
			NPC대화가능Y := 23
			NPC대화가능Z := 0
		}
		else if (목적지 = "마법상점")
		{
			목적지맵번호 := 4219
			NPC이름 := "리노스"
			목적지X := 135
			목적지Y := 119
			목적지Z := 1
			NPC대화가능X := 38
			NPC대화가능Y := 21
			NPC대화가능Z := 0
		}
		else if (목적지 = "여관")
		{
			목적지맵번호 := 4210
			NPC이름 := "코르티"
			목적지X := 135
			목적지Y := 75
			목적지Z := 1
			NPC대화가능X := 44
			NPC대화가능Y := 37
			NPC대화가능Z := 0
		}
	}
return
;}

마하디움링교환:
;{
gosub, 아이템읽어오기
반복횟수 := 0
a := 0
b := 0
a += floor(아이템갯수["마하디움"]/10)
b += floor(아이템갯수["아이언링"]/2)
if (a < 1 || b < 1)
	return
else if (a > b)
	반복횟수 := b
else if (b > a)
	반복횟수 := a
SB_SetText("마하디움" a "번 가능" "아이언링" b "번 가능" 반복횟수 "만큼 반복",5)
loop, % 반복횟수
{
	호출할NPC := "루비"
	check := CallNPC(호출할NPC)
	sleep, 500
	if (check=0)
		break
	NPCMENUSELECT("Talk")
	sleep, 500
	loop, 3
	{
		KeyClick("K6")
		sleep,100
	}
	temp := get_NPCTalk_cordi()
	x:=temp.x
	y:=temp.y + 28 ; 마하디움링
	MouseClick(x,y)
	sleep, 500
	loop, 7
	{
		KeyClick("K6")
		sleep,100
	}
	MouseClickRightButton(x,y)
}
return
;}
포레스트네자동대화실행:
;{
	gui, submit, nohide
	NPC_TALK_DELAYCOUNT := 0
	NPC대화딜레이 := 0
	guicontrol,,NPC대화딜레이,%NPC대화딜레이%
	gosub, 포레스트네자동감응
	Return
;}

포레스트네자동감응:
;{
gosub, 기본정보읽기
gui, submit, nohide
SB_SetText("NPC자동대화시작",2)
공격여부 := mem.read(0x0058DAD4, "UInt", 0x178, 0xEB)
맵번호 := mem.read(0x0058EB1C, "UInt", 0x10E)
if (포레스트네자동대화 == 0)
{
	return
}
else if (맵번호 != 4003 && 맵번호 != 4005)
{
	NPC대화딜레이 := NPC대화딜레이 - 2
	guicontrol,,NPC대화딜레이,%NPC대화딜레이%
	SB_SetText("NPC자동대화지역이아님",2)
	return
}
else if (맵번호 = 4003)
{
	SB_SetText("NPC자동대화시작 - 포북",2)
	gosub, 아이템읽어오기
	if(아이템갯수["빛나는가루"] < 10 || 아이템갯수["빛나는가루"] = "" )
	{
		NPC대화딜레이 := NPC대화딜레이 - 1
		guicontrol,,NPC대화딜레이,%NPC대화딜레이%
		return
	}

	NPC대화창사용중 := True
	if !(위치고정 = 1)
	{
		CheatEngine_DoNotMove()
	}
	if (공격여부 != 0 && 자동사냥여부 = 1)
	{
		keyclick("Tab")
		sleep, 350
		keyclick("Tab")
		sleep, 350
	}
	loop,
	{
		sleep,1000
		SB_SetText("포북: 길잃은수색대 호출",2)
		호출할NPC := "길잃은수색대"
		호출할NPCOID존재여부 := CallNPC(호출할NPC)
		if(호출할NPCOID존재여부 = 1)
		{
			break
		}
		else
		{
			SB_SetText("포북, 길잃은수색대에게 가는중",2)
			좌표입력(200,121,1)
			RunMemory("좌표이동")
			continue
		}

	}

	if ((NPC_MSG_ADR = "없음") || (NPC_MSG_ADR < 1))
	{
		sleep, 500
		SetFormat, Integer, H
		startAddress := 0x00100000
		endAddress := 0x00200000
		NPC_MSG_ADR := mem.processPatternScan(startAddress, endAddress, 0x74, 0xC7, 0xF0, 0xB7, 0x20, 0x00, 0xF3, 0xAC, 0x4C, 0xAE, 0xC0, 0xC9, 0x20, 0x00) ; "이런곳 까지" 를 검색
		SetFormat, Integer, D
		SB_SetText("NPC대화주소검색중" NPC_MSG_ADR,2)
		GuiControl,, NPC_MSG_ADR, %NPC_MSG_ADR%
		sleep, 100
	}
	Loop,
	{
		sleep,1000
		NPCMsg := mem.readString(NPC_MSG_ADR, 52, "UTF-16", aOffsets*)
		FormNumber := mem.read(0x0058DAD0, "UInt", 0xC, 0x10, 0x8, 0xA0)
		ifinstring, NPCMsg,이런 곳
		{
			mem.writeString(Result_Msg_Addr, "", "UTF-16", aOffsets*)
			keyclick("K6")
			break
		}
		else
		{
			CallNPC(호출할NPC)
			sleep, 1000
		}

	}

	도움필요 := True
	포북대화 := True
	가루교환필요 := floor((아이템갯수["빛나는가루"] - 10 ) / 100)
	나뭇가지교환필요 := floor(아이템갯수["빛나는나뭇가지"] / 20)
	결정교환필요 := floor(아이템갯수["빛나는결정"] / 100)
	교환필요 := 가루교환필요 + 나뭇가지교환필요 + 결정교환필요
	loop,
	{
		sleep,100
		교환필요 := 가루교환필요 + 나뭇가지교환필요 + 결정교환필요
		NPCMsg := mem.readString(NPC_MSG_ADR, 50, "UTF-16", aOffsets*)
		temp := get_NPCTalk_cordi()
		x:=temp.x
		y:=temp.y
		FormNumber := mem.read(0x0058DAD0, "UInt", 0xC, 0x10, 0x8, 0xA0)
		ifinstring,NPCMsg,무슨 일로
		{
			;FormNumber = 117
			keyclick("k6")
			mem.writeString(Result_Msg_Addr, "", "UTF-16", aOffsets*)
			if (도움필요)
			{
				x+=10
				y+=19
				MouseClick(x,y) ;도움을주세요
			}
			else if (교환필요 > 0)
			{
				x-=24
				y+=31
				MouseClick(x,y) ;교환
				sleep, 350
				if (가루교환필요 > 0)
				{
					SB_SetText("가루교환 " 가루교환필요 "회 남음" , 2)
					가루교환필요 -= 1
					x:=temp.x
					y:=temp.y -5
					MouseClick(x,y)
				}
				else if (나뭇가지교환필요 > 0)
				{
					SB_SetText("나뭇가지교환 " 나뭇가지교환필요 "회 남음" , 2)
					나뭇가지교환필요 -= 1
					x:=temp.x
					y:=temp.y + 8
					MouseClick(x,y)
				}
				else if (결정교환필요 > 0)
				{
					SB_SetText("결정교환 " 결정교환필요 "회 남음" , 2)
					결정교환필요 -= 1
					x:=temp.x
					y:=temp.y + 21
					MouseClick(x,y)
				}
			}
			else
			{
				x-=49
				y+=43
				MouseClick(x,y) ;종료
			}
		}
		else ifinstring,NPCMsg,해독약을
		{
			;FormNumber = 77
			y+=27
			mem.writeString(Result_Msg_Addr, "", "UTF-16", aOffsets*)
			keyclick("k6")
			MouseClick(x,y)
		}
		else ifinstring,NPCMsg,빛나는결정을 얻다
		{
			;FormNumber = 77
			mem.writeString(Result_Msg_Addr, "", "UTF-16", aOffsets*)
			keyclick("k6")
		}
		else ifinstring,NPCMsg,를 얻다
		{
			;FormNumber = 77
			mem.writeString(Result_Msg_Addr, "", "UTF-16", aOffsets*)
			keyclick("k6")
			keyclick("k6")
			keyclick("k6")
		}
		else ifinstring,NPCMsg,이런 곳까지 오
		{
			;FormNumber = 77
			mem.writeString(Result_Msg_Addr, "", "UTF-16", aOffsets*)
			keyclick("k6")
			keyclick("k6")
			keyclick("k6")
		}
		else ifinstring,NPCMsg,어떤 도움을
		{
			;FormNumber = 93
			x-=20
			y+=20
			mem.writeString(Result_Msg_Addr, "", "UTF-16", aOffsets*)
			MouseClick(x,y)
		}
		else ifinstring,NPCMsg,이 마법은 사실
		{
			;FormNumber = 77
			mem.writeString(Result_Msg_Addr, "", "UTF-16", aOffsets*)
			keyclick("k6")
		}
		else ifinstring,NPCMsg,어떤 몬스터에
		{
			mem.writeString(Result_Msg_Addr, "", "UTF-16", aOffsets*)
			x-=20
			y+=38
			MouseClick(x,y) ;종료
			keyclick("k6")
		}
		else ifinstring,NPCMsg,개인적으로
		{
			;FormNumber = 77
			mem.writeString(Result_Msg_Addr, "", "UTF-16", aOffsets*)
			keyclick("k6")
		}
		else ifinstring,NPCMsg,이 마법에
		{
			;FormNumber = 77
			mem.writeString(Result_Msg_Addr, "", "UTF-16", aOffsets*)
			keyclick("k6")
		}
		else ifinstring,NPCMsg,트렌트와
		{
			;FormNumber = 77
			mem.writeString(Result_Msg_Addr, "", "UTF-16", aOffsets*)
			keyclick("k6")
		}
		else ifinstring,NPCMsg,효과를 얻다
		{
			mem.writeString(Result_Msg_Addr, "", "UTF-16", aOffsets*)
			;FormNumber = 77
			keyclick("k6")
			도움필요 := False
		}
		else ifinstring,NPCMsg,부족합니다
		{
			mem.writeString(Result_Msg_Addr, "", "UTF-16", aOffsets*)
			;FormNumber = 77
			keyclick("k6")
			도움필요 := False
		}
		else ifinstring,NPCMsg,빛나는가루 10개를
		{
			;FormNumber = 81
			x-=16
			y+=13
			mem.writeString(Result_Msg_Addr, "", "UTF-16", aOffsets*)
			MouseClick(x,y)
			도움필요 := False
		}
		else ifinstring,NPCMsg,빛나는가루가 부족합
		{
			;FormNumber = 77
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
		공격여부 := mem.read(0x0058DAD4, "UInt", 0x178, 0xEB)
		gui,listview,몬스터리스트
		현재대상 := lv_getnext(0)
		if (공격여부 = 0 && 자동사냥여부 = 1 && 현재대상 != 0)
		{
			RunMemory("공격하기")
		}
		NPC대화창사용중 := False
		guicontrol,,NPC대화딜레이,0
		SB_SetText("NPC자동대화완료",2)
		if (위치고정 != 1)
			CheatEngine_CancelDoNotMove()
		return

}
else if (맵번호 = 4005)
{
	SB_SetText("NPC자동대화시작 - 포남",2)
	한턴쉴까 := False
	gui,listview,몬스터리스트
	loop % LV_GetCount()
	{
		LV_GetText(몬스터이름,A_index,5)
		if (몬스터이름 = "만드")
		{
			NPC대화딜레이 := NPC대화딜레이 - 1
			guicontrol,,NPC대화딜레이,%NPC대화딜레이%
			한턴쉴까 := True
			break
		}
	}
	if (한턴쉴까 = True)
	{
		SB_SetText("맵에 만드가 있어 대화를 한턴 쉽니다",2)
		return
	}
	else if (한턴쉴까 = False)
	{
		공격여부 := mem.read(0x0058DAD4, "UInt", 0x178, 0xEB)
		if (공격여부 != 0)
		{
			keyclick("Tab")
			sleep, 350
			keyclick("Tab")
			sleep, 350
		}
		;동쪽파수꾼
		;4005 185 34 1
		;서쪽파수꾼
		;4005 33 169 1
		NPC대화창사용중 := True

		if !(다음대화꾼 = "서쪽파수꾼")
			다음대화꾼 := "서쪽파수꾼"
		else
			다음대화꾼 := "동쪽파수꾼"
		callnpc(다음대화꾼)
		if ((NPC_MSG_ADR = "없음") || (NPC_MSG_ADR < 1))
		{
			sleep, 500
			SetFormat, Integer, H
			startAddress := 0x00100000
			endAddress := 0x00200000
			NPC_MSG_ADR := mem.processPatternScan(startAddress, endAddress, 0x5B, 0x00, 0xD9, 0xB3, 0xBD, 0xCA, 0x0C, 0xD3, 0x18, 0xC2, 0xBC, 0xAF, 0x5D, 0x00) ; "[동쪽파수꾼]" 를 검색
			if ((NPC_MSG_ADR = "없음") || (NPC_MSG_ADR < 1))
			{
				sleep, 500
				SetFormat, Integer, H
				startAddress := 0x00100000
				endAddress := 0x00200000
				NPC_MSG_ADR := mem.processPatternScan(startAddress, endAddress, 0x5B, 0x00, 0x1C, 0xC1, 0xBD, 0xCA, 0x0C, 0xD3, 0x18, 0xC2, 0xBC, 0xAF, 0x5D, 0x00) ; "[서쪽파수꾼]" 를 검색
				if ((NPC_MSG_ADR = "없음") || (NPC_MSG_ADR < 1))
				{
					sleep, 500
					SetFormat, Integer, H
					startAddress := 0x00100000
					endAddress := 0x00200000
					NPC_MSG_ADR := mem.processPatternScan(startAddress, endAddress, 0xB4, 0xC5, 0xBB, 0xB5, 0x8C, 0xAC, 0x20, 0x00, 0xEC, 0xC5, 0x30, 0xAE, 0x4C, 0xAE) ; "어떻게 여기까" 를 검색
					SetFormat, Integer, D
					SB_SetText("NPC대화주소검색중" NPC_MSG_ADR,2)
					GuiControl,, NPC_MSG_ADR, %NPC_MSG_ADR%
					sleep, 100
				}
				SetFormat, Integer, D
				SB_SetText("NPC대화주소검색중" NPC_MSG_ADR,2)
				GuiControl,, NPC_MSG_ADR, %NPC_MSG_ADR%
				sleep, 100
			}
			SetFormat, Integer, D
			SB_SetText("NPC대화주소검색중" NPC_MSG_ADR,2)
			GuiControl,, NPC_MSG_ADR, %NPC_MSG_ADR%
			sleep, 100
		}


		loop, 5
		{
			sleep,1000
			NPCMsg := mem.readString(NPC_MSG_ADR, 52, "UTF-16", aOffsets*)
			FormNumber := mem.read(0x0058DAD0, "UInt", 0xC, 0x10, 0x8, 0xA0)
			if(instr(NPCMSG,"어떻게")||instr(NPCMSG,"아직"))
			{
				mem.writeString(NPC_MSG_ADR, "", "UTF-16", aOffsets*)
				KeyClick("K6")
				sleep,100
				KeyClick("K6")
				break
			}
			else if (instr(NPCMSG,"만나고 와"))
			{
				KeyClick("K6")
				sleep,100
				KeyClick("K6")
				mem.writeString(NPC_MSG_ADR, "", "UTF-16", aOffsets*)
				if !(다음대화꾼 = "서쪽파수꾼")
					다음대화꾼 := "서쪽파수꾼"
				else
					다음대화꾼 := "동쪽파수꾼"
				sleep, 1
				callnpc(다음대화꾼)
			}
			else
				callnpc(다음대화꾼)
		}
		sleep,1000
		FormNumber := mem.read(0x0058DAD0, "UInt", 0xC, 0x10, 0x8, 0xA0)
		if (FormNumber !=0)
		{
			KeyClick("K6")
		}

		공격여부 := mem.read(0x0058DAD4, "UInt", 0x178, 0xEB)

		if (공격여부 = 0 && 자동사냥여부 = 1)
		{
			RunMemory("공격하기")
		}

		NPC대화창사용중 := False
		NPC대화딜레이 := 0
		guicontrol,,NPC대화딜레이,0
		SB_SetText("NPC자동대화완료",2)
	}
	return
}

Return
;}

골드바사기:
골드바어떻게 := "구매"
SB_SetText("골드바구매",1)
gosub, 골드바
return

골드바팔기:
골드바어떻게 := "판매"
SB_SetText("골드바판매",1)
gosub, 골드바
return

골드바:
;{
	목적마을 := "포프레스네"
	목적지 := "은행"
	gosub, 포프레스네상점이동세팅
	loop,
	{
		sleep, 1000
		;if (CurrentMode = "대기모드")
		;	continue

		맵번호 := mem.read(0x0058EB1C, "UInt", 0x10E)
		맵이름 := mem.readString(mem.getModuleBaseAddress("jelancia_core.dll")+0x44A28, 50, "UTF-16", 0xC)
		Gui, ListView, NPC리스트
		LV_Delete()
		Setting_Reload("NPC리스트")
		좌표X := mem.read(0x0058DAD4, "UInt", 0x10)
		좌표Y := mem.read(0x0058DAD4, "UInt", 0x14)
		좌표Z := mem.read(0x0058DAD4, "UInt", 0x18)
		IsMoving := mem.read(0x0058EB1C, "UInt", 0x174)
		SB_SetText(목적마을 목적지 " 가는중",2)
		Dimension := mem.read(0x0058EB1C, "UInt", 0x10A)
		if(Dimension>20000)
			차원:="감마"
		else if(Dimension>10000)
			차원:="베타"
		else if(Dimension<10000)
			차원:="알파"
		if (맵번호 = 목적지맵번호 && 차원 = "알파")
		{
			InStep := 2
		}
		else if (맵번호 = 목적마을맵번호  && 차원 = "알파")
		{
			InStep := 1
		}
		else if (IsDataInList(맵번호, 나가기가능맵) && 차원 = "알파") ;마을의 베이커리 ; 마법상점 ; 안이라면
		{
			gosub, 상점나가기
			continue
		}
		else
		{
			sleep, 1
			목적차원 := 차원
			라깃사용하기(목적마을,"알파")
			sleep, 100
			continue
		}
		if ( InStep = 1 )
		{
			if (isMoving = 0)
			{
				좌표입력(목적지X,목적지Y,목적지Z)
				sleep, 1
				RunMemory("좌표이동")
			}
			continue
		}
		else if ( InStep = 2 )
		{
			if (isMoving = 0)
			{
				if ( CallNPC(NPC이름) = 1)
					break
				좌표입력(NPC대화가능X,NPC대화가능Y,NPC대화가능Z)
				sleep, 1
				RunMemory("좌표이동")
			}
			continue
		}
	}
	SB_SetText("드골호출완료",2)
	if ((NPC_MSG_ADR = "없음") || (NPC_MSG_ADR < 1))
	{
		sleep, 500
		SetFormat, Integer, H
		startAddress := 0x00100000
		endAddress := 0x00200000
		NPC_MSG_ADR := mem.processPatternScan(startAddress, endAddress, 0x5B, 0x00, 0xE8, 0xAC, 0xDC 0xB4, 0x14, 0xBC, 0x5D, 0x00) ; "[골드바]" 를 검색
		SetFormat, Integer, D
		SB_SetText("NPC대화주소검색중" NPC_MSG_ADR,2)
		GuiControl,, NPC_MSG_ADR, %NPC_MSG_ADR%
		sleep, 100
	}

	if ((NPC_MSG_ADR = "없음") || (NPC_MSG_ADR < 1))
	{
		SB_SetText("NPC대화주소검색실패" NPC_MSG_ADR,2)
		return
	}
	sleep, 1000
	NPCMsg := mem.readString(NPC_MSG_ADR, 52, "UTF-16", aOffsets*)
	FormNumber := mem.read(0x0058DAD0, "UInt", 0xC, 0x10, 0x8, 0xA0)

	if (골드바어떻게 = "판매")
	{
		SB_SetText("골드바팔기시도",2)
		loop,
		{
			sleep, 500
			NPCMsg := mem.readString(NPC_MSG_ADR, 52, "UTF-16", aOffsets*)
			;[팔기]
			IfInString,NPCMsg,사고 팔
			{
				mem.writeString(NPC_MSG_ADR, "", "UTF-16", aOffsets*)
				temp:=get_NPCTalk_cordi()
				x:=temp.x - 6
				y:=temp.y + 21
				MouseClick(x,y)
			}
			;[골드바] 하나에 8,500,000갈리드... 팔건가?
			else IfInString,NPCMsg,하나
			{
				mem.writeString(NPC_MSG_ADR, "", "UTF-16", aOffsets*)
				temp:=get_NPCTalk_cordi()
				x:=temp.x - 15
				y:=temp.y + 14
				MouseClick(x,y)
			}
			;내가 늙었다고 속이려는건가... [골드바]를 가져오게...
			else IfInString,NPCMsg,내가 늙었다고
			{
				mem.writeString(NPC_MSG_ADR, "", "UTF-16", aOffsets*)
				temp:=get_NPCTalk_cordi()
				keyclick("K6")
				골드바어떻게 := "종료"
				break
			}
			else IfInString, NPCMsg, 여기
			{
				mem.writeString(NPC_MSG_ADR, "", "UTF-16", aOffsets*)
				temp:=get_NPCTalk_cordi()
				keyclick("K6")
				골드바어떻게 := "종료"
				break
			}
		}
	}
	else if (골드바어떻게 = "구매")
	{
		SB_SetText("골드바구매시도",2)
		loop,
		{
			sleep, 500
			NPCMsg := mem.readString(NPC_MSG_ADR, 52, "UTF-16", aOffsets*)
			SB_SetText(NPCMsg,2)
			;[팔기]
			IfInString, NPCMsg, 사고 팔
			{
				mem.writeString(NPC_MSG_ADR, "", "UTF-16", aOffsets*)
				temp:=get_NPCTalk_cordi()
				x:=temp.x - 6
				y:=temp.y + 8
				MouseClick(x,y)
			}
			;[골드바] 하나에 8,500,000갈리드... 팔건가?
			else IfInString, NPCMsg, 하나
			{
				mem.writeString(NPC_MSG_ADR, "", "UTF-16", aOffsets*)
				temp:=get_NPCTalk_cordi()
				x:=temp.x - 15
				y:=temp.y + 14
				MouseClick(x,y)
			}
			;내가 늙었다고 속이려는건가... [골드바]를 가져오게...
			else IfInString, NPCMsg, 돈이 부족한
			{
				mem.writeString(NPC_MSG_ADR, "", "UTF-16", aOffsets*)
				temp:=get_NPCTalk_cordi()
				keyclick("K6")
				골드바어떻게 := "종료"
				break
			}
			else IfInString, NPCMsg, 여기
			{
				mem.writeString(NPC_MSG_ADR, "", "UTF-16", aOffsets*)
				temp:=get_NPCTalk_cordi()
				keyclick("K6")
				골드바어떻게 := "종료"
				break
			}
		}
	}
	sleep,1000
	NPCMsg := mem.readString(NPC_MSG_ADR, 52, "UTF-16", aOffsets*)
	if (골드바어떻게 = "종료")
	{
		IfInString,NPCMsg,사고 팔
		{
			mem.writeString(NPC_MSG_ADR, "", "UTF-16", aOffsets*)
			temp:=get_NPCTalk_cordi()
			x:=temp.x - 6
			y:=temp.y + 34
			MouseClick(x,y)
		}
	}
	sleep,1000
return
;}

무기수리강제:
무기수리필요 := true
무기수리:
;{
	목적마을 := "포프레스네"
	목적지 := "무기상점"
	동작방법 := "Repair"
	gosub, 포프레스네상점이동세팅

	loop,
	{
		sleep, 1000
		;if (CurrentMode = "대기모드")
		;	continue

		맵번호 := mem.read(0x0058EB1C, "UInt", 0x10E)
		맵이름 := mem.readString(mem.getModuleBaseAddress("jelancia_core.dll")+0x44A28, 50, "UTF-16", 0xC)
		Gui, ListView, NPC리스트
		LV_Delete()
		Setting_Reload("NPC리스트")
		좌표X := mem.read(0x0058DAD4, "UInt", 0x10)
		좌표Y := mem.read(0x0058DAD4, "UInt", 0x14)
		좌표Z := mem.read(0x0058DAD4, "UInt", 0x18)
		IsMoving := mem.read(0x0058EB1C, "UInt", 0x174)
		SB_SetText(목적마을 목적지 " 가는중",2)
		if (맵번호 = 목적지맵번호)
		{
			InStep := 2
		}
		else if (맵번호 = 목적마을맵번호)
		{
			InStep := 1
		}
		else if (IsDataInList(맵번호, 나가기가능맵)) ;마을의 베이커리 ; 마법상점 ; 안이라면
		{
			gosub, 상점나가기
			continue
		}
		else
		{
			Dimension := mem.read(0x0058EB1C, "UInt", 0x10A)
			if(Dimension>20000)
				차원:="감마"
			else if(Dimension>10000)
				차원:="베타"
			else if(Dimension<10000)
				차원:="알파"
			sleep, 1
			목적차원 := 차원
			라깃사용하기(목적마을,목적차원)
			sleep, 100
			continue
		}

		if ( InStep = 1 )
		{
			if (isMoving = 0)
			{
				좌표입력(목적지X,목적지Y,목적지Z)
				sleep, 1
				RunMemory("좌표이동")
			}
			continue
		}
		else if ( InStep = 2 )
		{
			if (isMoving = 0)
			{
				if ( CallNPC(NPC이름) = 1)
					break
				좌표입력(NPC대화가능X,NPC대화가능Y,NPC대화가능Z)
				sleep, 1
				RunMemory("좌표이동")

			}
			continue
		}
	}
	SB_SetText(NPC이름 " 근처에 가는중",2)
	loop, 5
	{
		NpcMenuSelection := mem.read(0x0058F0A4, "UInt", aOffset*) ; 메뉴창이 잘 떳는지 확인
		if (NpcMenuSelection = 0)
		{
			SB_SetText("NPC호출실패 다시호출",2)
			CallNPC(NPC이름)
		}
		else
		{
			SB_SetText("NPC호출성공",2)
			break
		}
		sleep, 100
	}

	loop, 5
	{
		NPCMENUSELECT(동작방법)
		sleep, 100
		if (Check_Shop(동작방법)!=0)
			break
	}
	무기수리필요여부확인 := 0
	무기수리필요 := False
	guicontrol, ,무기수리필요상태,%무기수리필요%

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
	sleep, 500
	gosub, 상점나가기

return
;}

그레이드하기:
;{
gosub, 어빌리티읽어오기
gosub, 마법읽어오기
gui, submit, nohide
;최소충족조건
GALRID := mem.read(0x0058DAD4, "UInt", 0x178, 0x6F)
GuiControl,, GALRID, % GALRID
if !(GALRID > 1000000 && 아이템갯수["정령의보석"] > 10)
{
	그레이드필요 := False
	;return
}
맵번호 := mem.read(0x0058EB1C, "UInt", 0x10E)
if (맵번호 = 2 || 맵번호 = 229 )
	목적마을 := "로렌시아"
else if (맵번호 = 1002 || 맵번호 = 1229 )
	목적마을 := "에필로리아"
else if (맵번호 = 2002 || 맵번호 = 2229 )
	목적마을 := "세르니카"
else if (맵번호 = 3002 || 맵번호 = 3229 )
	목적마을 := "크로노시스"
else
	목적마을 := "포프레스네"
목적지 := "신전"
gosub, 배달상점이동세팅
gosub, 배달상점가기
settimer, 스킬사용하기, off
if (Multiplyer = "없음" || Multiplyer < 1)
	gosub, 일랜시아창크기구하기
loop,
{
	sleep,1
	KeyClick("Enter")
	sleep,1
	IfWinNotActive,ahk_pid %jPID%
	{
		WinActivate, ahk_pid %jPID%
		Sleep, 100
	}
	ime_status := % IME_CHECK("A")
	if (ime_status = "0")
	{
		Send, {vk15sc138}
		Sleep, 1000
	}
	Send, rleh{Enter}
	sleep, 500
	if (NPC_MSG_ADR = "없음") || (NPC_MSG_ADR < 1)
	{
		SetFormat, Integer, H
		startAddress := 0x00100000
		endAddress :=  0x00200000
		NPC_MSG_ADR := mem.processPatternScan(startAddress, endAddress, 0xF9, 0xB2, 0xE0, 0xC2, 0x58, 0xC7, 0x20, 0x00, 0x31, 0xC1, 0xA5, 0xD5, 0x28, 0x00) ; "당신의 성향은" 검색
		SetFormat, Integer, D
		SB_SetText("NPC대화주소검색중" NPC_MSG_ADR,2)
		GuiControl,, NPC_MSG_ADR, %NPC_MSG_ADR%
		sleep, 100
		continue
	}
	FormNumber := mem.read(0x0058DAD0, "UInt", 0xC, 0x10, 0x8, 0xA0)
	if (FormNumber = 52 || FormNumber = 92)
		break
}
loop,
{
	sleep, 500
	NPCMsg := mem.readString(NPC_MSG_ADR, 100, "UTF-16", aOffsets*)
	FormNumber := mem.read(0x0058DAD0, "UInt", 0xC, 0x10, 0x8, 0xA0)
	IfInString,NPCMsg,올랐습니다!
	{
		SB_SetText("그레이드중완료",2)
		keyClick("K6")
		sleep,10
		break
	}
	else IfInString,NPCMsg,[%그레이드할어빌%]의
	{
		SB_SetText("그레이드중완료",2)
		keyClick("K6")
		sleep,10
		break
	}
	else IfInString,NPCMsg,당신의 성향
	{
		SB_SetText("그레이드중 - 기도성공",2)
		mem.writeString(NPC_MSG_ADR, "", "UTF-16", aOffsets*)
		KeyClick("K6")
		sleep,10
		continue
	}
	else IfInString,NPCMsg,성향이 떨어지면
	{
		SB_SetText("그레이드중 - 2",2)
		mem.writeString(NPC_MSG_ADR, "", "UTF-16", aOffsets*)
		KeyClick("K6")
		sleep,10
		continue
	}
	else IfInString,NPCMsg,를 올리시려구요
	{
		SB_SetText("그레이드중 - 3",2)
		mem.writeString(NPC_MSG_ADR, "", "UTF-16", aOffsets*)
		KeyClick("K6")
		sleep,10
		continue
	}
	else IfInString,NPCMsg,갈리드의 비용과 신전에
	{
		SB_SetText("그레이드중 - 4",2)
		mem.writeString(NPC_MSG_ADR, "", "UTF-16", aOffsets*)
		KeyClick("K6")
		sleep,10
		continue
	}
	else IfInString,NPCMsg,무엇을 도와드릴까요
	{
		SB_SetText("그레이드중 - 5",2)
		mem.writeString(NPC_MSG_ADR, "", "UTF-16", aOffsets*)
		 ; 그레이드 클릭
		temp:=get_NPCTalk_cordi()
		x:=temp.x - 20
		y:=temp.y + 6  ; 그레이드 클릭
		MouseClick(x,y)
		sleep,10
		continue
	}
	else IfInString,NPCMsg,어떤 것을 도와 드릴까요
	{
		SB_SetText("그레이드중 - 6",2)
		mem.writeString(NPC_MSG_ADR, "", "UTF-16", aOffsets*)
		 ; 그레이드 클릭
		temp:=get_NPCTalk_cordi()
		x:=temp.x - 40
		y:=temp.y  ; 그레이드 올리기 클릭
		MouseClick(x,y)
		sleep,10
		continue
	}
	else IfInString,NPCMsg,를 올리시겠습니까
	{
		SB_SetText("그레이드중 - 7",2)
		mem.writeString(NPC_MSG_ADR, "", "UTF-16", aOffsets*)
		temp:=get_NPCTalk_cordi()
		x:=temp.x - 15
		y:=temp.y - 5
		MouseClick(x,y)
		sleep,10
		continue
	}
	else IfInString,NPCMsg,올리려는 것을 선택하세요
	{
		SB_SetText("그레이드중 - 8",2)
		mem.writeString(NPC_MSG_ADR, "", "UTF-16", aOffsets*)
		temp:=get_NPCTalk_cordi()
		x:=temp.x - 20
		if (그레이드종류 = "어빌")
			y:=temp.y - 11 ; 어빌리티
		else if (그레이드종류 = "마법")
			y:=temp.y ; 스펠
		MouseClick(x,y)
		sleep,10
		continue
	}
	else IfInString,NPCMsg,부족합니다
	{
		SB_SetText("그레이드중 - 12",2)
		mem.writeString(NPC_MSG_ADR, "", "UTF-16", aOffsets*)
		KeyClick("K6")
		sleep,10
		break
	}
	else IfInString,NPCMsg,어빌리티를 마스터
	{
		SB_SetText("그레이드중 - 9",2)
		mem.writeString(NPC_MSG_ADR, "", "UTF-16", aOffsets*)
		temp:=get_NPCTalk_cordi()
		x:=temp.x -6
		y:=temp.y + 20
		MouseClick(x,y)
		sleep,10
		break
	}
	else IfInString,NPCMsg,잘못된
	{
		SB_SetText("그레이드중 - 13",2)
		mem.writeString(NPC_MSG_ADR, "", "UTF-16", aOffsets*)
		temp:=get_NPCTalk_cordi()
		x:=temp.x - 10
		y:=temp.y + 5
		MouseClick(x,y)
		sleep,10
		break
	}
	else if(FormNumber = 38)
	{
		SB_SetText("그레이드중 - 10" 그레이드할어빌 ,2)
		mem.writeString(NPC_MSG_ADR, "", "UTF-16", aOffsets*)
		IfWinNotActive,ahk_pid %jPID%
		{
		WinActivate, ahk_pid %jPID%
		}
		sleep, 10
		if (그레이드종류 = "어빌")
			SendWeaponName(그레이드할어빌)
		else if (그레이드종류 = "마법")
			SendMagicName(그레이드할어빌)
		continue
	}
	else IfInString,NPCMsg,%그레이드할어빌%
	{
		SB_SetText("그레이드중 - 11",2)
		mem.writeString(NPC_MSG_ADR, "", "UTF-16", aOffsets*)
		temp:=get_NPCTalk_cordi()
		x:=temp.x - 10
		y:=temp.y
		MouseClick(x,y)
		sleep,10
		break
	}
}
FormNumber := mem.read(0x0058DAD0, "UInt", 0xC, 0x10, 0x8, 0xA0)
if FormNumber != 0
	KeyClick("K6")
return


SendWeaponName(WeaponName)
{
if(WeaponName = "격투")
{
ime_status := % IME_CHECK("A")
if (ime_status = "0")
{
Send, {vk15sc138}
Sleep, 100
}
Send, rurxn{Enter}
}
if(WeaponName = "검")
{
ime_status := % IME_CHECK("A")
if (ime_status = "0")
{
Send, {vk15sc138}
Sleep, 100
}
Send, rja{Enter}
}
if(WeaponName = "단검")
{
ime_status := % IME_CHECK("A")
if (ime_status = "0")
{
Send, {vk15sc138}
Sleep, 100
}
Send, eksrja{Enter}
}
if(WeaponName = "도")
{
ime_status := % IME_CHECK("A")
if (ime_status = "0")
{
Send, {vk15sc138}
Sleep, 100
}
Send, eh{Enter}
}
if(WeaponName = "도끼")
{
ime_status := % IME_CHECK("A")
if (ime_status = "0")
{
Send, {vk15sc138}
Sleep, 100
}
Send, ehRl{Enter}
}
if(WeaponName = "거대도끼")
{
ime_status := % IME_CHECK("A")
if (ime_status = "0")
{
Send, {vk15sc138}
Sleep, 100
}
Send, rjeoehRl{Enter}
}
if(WeaponName = "대검")
{
ime_status := % IME_CHECK("A")
if (ime_status = "0")
{
Send, {vk15sc138}
Sleep, 100
}
Send, eorja{Enter}
}
if(WeaponName = "대도")
{
ime_status := % IME_CHECK("A")
if (ime_status = "0")
{
Send, {vk15sc138}
Sleep, 100
}
Send, eoeh{Enter}
}
if(WeaponName = "창, 특수창")
{
ime_status := % IME_CHECK("A")
if (ime_status = "0")
{
Send, {vk15sc138}
Sleep, 100
}
Send, ckd,{Space}xmrtnckd{Enter}
}
if(WeaponName = "봉, 해머")
{
ime_status := % IME_CHECK("A")
if (ime_status = "0")
{
Send, {vk15sc138}
Sleep, 100
}
Send, qhd,{Space}goaj{Enter}
}
if(WeaponName = "현금")
{
ime_status := % IME_CHECK("A")
if (ime_status = "0")
{
Send, {vk15sc138}
Sleep, 100
}
Send, gusrma{Enter}
}
if(WeaponName = "활")
{
ime_status := % IME_CHECK("A")
if (ime_status = "0")
{
Send, {vk15sc138}
Sleep, 100
}
Send, ghkf{Enter}
}
if(WeaponName = "거대검")
{
ime_status := % IME_CHECK("A")
if (ime_status = "0")
{
Send, {vk15sc138}
Sleep, 100
}
Send, rjeorja{Enter}
}
if(WeaponName = "거대도")
{
ime_status := % IME_CHECK("A")
if (ime_status = "0")
{
Send, {vk15sc138}
Sleep, 100
}
Send, rjeoeh{Enter}
}
if(WeaponName = "양손단검")
{
ime_status := % IME_CHECK("A")
if (ime_status = "0")
{
Send, {vk15sc138}
Sleep, 100
}
Send, didthseksrja{Enter}
}
if(WeaponName = "양손도끼")
{
ime_status := % IME_CHECK("A")
if (ime_status = "0")
{
Send, {vk15sc138}
Sleep, 100
}
Send, didthsehRl{Enter}
}
if(WeaponName = "스태프")
{
ime_status := % IME_CHECK("A")
if (ime_status = "0")
{
Send, {vk15sc138}
Sleep, 100
}
Send, tmxovm{Enter}
}
if(WeaponName = "대화")
{
ime_status := % IME_CHECK("A")
if (ime_status = "0")
{
Send, {vk15sc138}
Sleep, 100
}
Send, eoghk{Enter}
}
if(WeaponName = "명상")
{
ime_status := % IME_CHECK("A")
if (ime_status = "0")
{
Send, {vk15sc138}
Sleep, 100
}
Send, audtkd{Enter}
}
if(WeaponName = "집중")
{
ime_status := % IME_CHECK("A")
if (ime_status = "0")
{
Send, {vk15sc138}
Sleep, 100
}
Send, wlqwnd{Enter}
}
if(WeaponName = "회피")
{
ime_status := % IME_CHECK("A")
if (ime_status = "0")
{
Send, {vk15sc138}
Sleep, 100
}
Send, ghlvl{Enter}
}
if(WeaponName = "몸통지르기")
{
ime_status := % IME_CHECK("A")
if (ime_status = "0")
{
Send, {vk15sc138}
Sleep, 100
}
Send, ahaxhdwlfmrl{Enter}
}
if(WeaponName = "민첩향상")
{
ime_status := % IME_CHECK("A")
if (ime_status = "0")
{
Send, {vk15sc138}
Sleep, 100
}
Send, alscjqgidtkd{Enter}
}
if(WeaponName = "체력향상")
{
ime_status := % IME_CHECK("A")
if (ime_status = "0")
{
Send, {vk15sc138}
Sleep, 100
}
Send, cpfurgidtkd{Enter}
}
if(WeaponName = "활방어")
{
ime_status := % IME_CHECK("A")
if (ime_status = "0")
{
Send, {vk15sc138}
Sleep, 100
}
Send, ghkfqkddj{Enter}
}
if(WeaponName = "RemoveArmor")
{
ime_status := % IME_CHECK("A")
if (ime_status = "1")
{
Send, {vk15sc138}
Sleep, 100
}
Send, RemoveArmor{Enter}
}
if(WeaponName = "엘")
{
ime_status := % IME_CHECK("A")
if (ime_status = "0")
{
Send, {vk15sc138}
Sleep, 100
}
Send, dpf{Enter}
}
if(WeaponName = "테스")
{
ime_status := % IME_CHECK("A")
if (ime_status = "0")
{
Send, {vk15sc138}
Sleep, 100
}
Send, xptm{Enter}
}
if(WeaponName = "마하")
{
ime_status := % IME_CHECK("A")
if (ime_status = "0")
{
Send, {vk15sc138}
Sleep, 100
}
Send, akgk{Enter}
}
if(WeaponName = "브리깃드")
{
ime_status := % IME_CHECK("A")
if (ime_status = "0")
{
Send, {vk15sc138}
Sleep, 100
}
Send, qmflrltem{Enter}
}
if(WeaponName = "다뉴")
{
ime_status := % IME_CHECK("A")
if (ime_status = "0")
{
Send, {vk15sc138}
Sleep, 100
}
Send, eksb{Enter}
}
if(WeaponName = "브라키")
{
ime_status := % IME_CHECK("A")
if (ime_status = "0")
{
Send, {vk15sc138}
Sleep, 100
}
Send, qmfkzl{Enter}
}
}

SendMagicName(MagicName)
{
if(MagicName = "쿠로")
{
ime_status := % IME_CHECK("A")
if (ime_status = "0")
{
Send, {vk15sc138}
Sleep, 100
}
Send, znfh{Enter}
}
if(MagicName = "나프")
{
ime_status := % IME_CHECK("A")
if (ime_status = "0")
{
Send, {vk15sc138}
Sleep, 100
}
Send, skvm{Enter}
}
if(MagicName = "베네피쿠스")
{
ime_status := % IME_CHECK("A")
if (ime_status = "0")
{
Send, {vk15sc138}
Sleep, 100
}
Send, qpspvlzntm{Enter}
}
if(MagicName = "브리스")
{
ime_status := % IME_CHECK("A")
if (ime_status = "0")
{
Send, {vk15sc138}
Sleep, 100
}
Send, qmfltm{Enter}
}
if(MagicName = "파라스")
{
ime_status := % IME_CHECK("A")
if (ime_status = "0")
{
Send, {vk15sc138}
Sleep, 100
}
Send, vkfktm{Enter}
}
if(MagicName = "파스티")
{
ime_status := % IME_CHECK("A")
if (ime_status = "0")
{
Send, {vk15sc138}
Sleep, 100
}
Send, vktmxl{Enter}
}
if(MagicName = "다라")
{
ime_status := % IME_CHECK("A")
if (ime_status = "0")
{
Send, {vk15sc138}
Sleep, 100
}
Send, ekfk{Enter}
}
if(MagicName = "마스")
{
ime_status := % IME_CHECK("A")
if (ime_status = "0")
{
Send, {vk15sc138}
Sleep, 100
}
Send, aktm{Enter}
}
if(MagicName = "라크")
{
ime_status := % IME_CHECK("A")
if (ime_status = "0")
{
Send, {vk15sc138}
Sleep, 100
}
Send, fkzm{Enter}
}
if(MagicName = "슈키")
{
ime_status := % IME_CHECK("A")
if (ime_status = "0")
{
Send, {vk15sc138}
Sleep, 100
}
Send, tbzl{Enter}
}
if(MagicName = "클리드")
{
ime_status := % IME_CHECK("A")
if (ime_status = "0")
{
Send, {vk15sc138}
Sleep, 100
}
Send, zmfflem{Enter}
}
if(MagicName = "저주")
{
ime_status := % IME_CHECK("A")
if (ime_status = "0")
{
Send, {vk15sc138}
Sleep, 100
}
Send, wjwn{Enter}
}
if(MagicName = "번개")
{
ime_status := % IME_CHECK("A")
if (ime_status = "0")
{
Send, {vk15sc138}
Sleep, 100
}
Send, qjsro{Enter}
}
}

파티캐릭터재확인: ;서포터용
;{
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
		GetAllElanciaTitle(A_INDEX)
		sleep,1
	}
	return
;}

원격파티하기: ;서포터용
;{
	Gui, Submit, Nohide
	SetFormat, Integer, D
	loop, 10
	{
		캐릭터사용여부 := A_Index . "번캐릭터사용여부"
		GuiControlGet,사용여부,, %캐릭터사용여부%
		if(사용여부 = 1)
		{
			found := False
			임시이름 := A_Index . "번캐릭터명"
			GuiControlGet,파티타겟이름,,%임시이름%
			Target_P_OID := GetOidFromOtherElancia(파티타겟이름)
			if (파티타겟이름!="" && 파티타겟이름!=0)
			{
				gui,listview,플레이어리스트
				i := 1
				loop % LV_GetCount()
				{
					LV_GetText(원격파티대상이름,i,5)
					LV_GetText(원격파티대상OID,i,6)
					if (원격파티대상이름 == 파티타겟이름)
					{
						mem.write(0x0058FE20, 원격파티대상OID, "UInt", aOffsets*)
						RunMemory("파티걸기")
						SB_SetText("파티걸기 - " 파티타겟이름 원격파티대상OID,2)
						found := True
						break
					}
					i++
				}
			}
			if (found = False) && (파티타겟이름!="" && 파티타겟이름!=0)
			{
				mem.write(0x0058FE20, Target_P_OID, "UInt", aOffsets*)
				SB_SetText("파티걸기 - " 파티타겟이름 Target_P_OID ,2)
				RunMemory("파티걸기")
			}
		}
		else if (사용여부 = 0)
			SB_SetText(A_Index "캐릭터는 안해" ,2)
		sleep, 1
	}
	return
;}

일랜시아선택:
;{
	Gui,Submit,Nohide

	if (ElanciaTitle = "")
		return
	if (TargetTitle != "")
		gosub, SaveBeforeExit

	guicontrol,Disabled,ElanciaTitle

	TargetTitle := ElanciaTitle
	WinGet,jPID,PID,%TargetTitle%
	TargetPID := jPID
	mem := new _ClassMemory("ahk_pid " 0, "", hProcessCopy)
	mem := new _ClassMemory("ahk_pid " jPID, "", hProcessCopy)
	ThisWindowTitle := "일랜 - " . TargetTitle . ";"
	Gui, Show, ,%ThisWindowTitle%
	gosub, ReloadGuiOptions
;}

기본설정적용:
;{
	gui, submit, nohide
	gosub, 기본메모리쓰기
	gosub, 기본정보읽기
	gosub, Fill

	gosub, 사용자선택
	gosub, 어빌리티읽어오기
	gosub, 마법읽어오기
	gosub, 아이템읽어오기
	guicontrolget,시작시간
	guicontrolget,시작체력
	guicontrolget,시작FP
	if (시작시간 = "시작시간")
	{
		guicontrol, ,현재TargetTitle, %TargetTitle%
		지금시각 = %A_Now%
		FormatTime, 지금시각_R, %지금시각%, yyyy 년 MM월 dd일 HH:mm
		guicontrol, ,시작시간, %지금시각_R%
		guicontrol, ,시작체력, %최대HP%
		guicontrol, ,시작마력, %최대MP%
		guicontrol, ,시작밥통, %최대FP%
	}
	GetMoreInformation()
	기존맵번호 := 0

	if (CurrentMode = "상인어빌수련")
	{
		CurrentMode := "대기모드"
		guicontrol,,CurrentMode,%CurrentMode%
	}
	return
;}

일랜시아새로고침:
{
	ReadAllElanciaTitle()
	GuiControl,, ElanciaTitle, |
	GuiControl,, ElanciaTitle, % ElanTitles
	return
}

기본메모리쓰기:
;{
CheatEngine_NoAttackMotion()
sleep,1
CheatEngine_NoShowRide()
sleep,1
CheatEngine_Buy_Unlimitted()
sleep,1
CheatEngine_AllwaysShowMinimap()
sleep,1
WriteExecutableMemory("공속")
mem.write(0x00460813,0xE9,"Char", aOffsets*)
mem.write(0x00460814,0x1D,"Char", aOffsets*)
mem.write(0x00460815,0x73,"Char", aOffsets*)
mem.write(0x00460816,0x0C,"Char", aOffsets*)
mem.write(0x00460817,0x00,"Char", aOffsets*)
mem.write(0x00460818,0x90,"Char", aOffsets*)
mem.write(0x00460819,0x90,"Char", aOffsets*)
sleep,1
WriteExecutableMemory("은행넣기결정코드")
sleep,1
WriteExecutableMemory("2벗무바")
sleep,1
WriteExecutableMemory("은행넣기실행코드")
sleep,1
WriteExecutableMemory("은행빼기코드")
sleep,1
WriteExecutableMemory("하나씩소각코드")
sleep,1
WriteExecutableMemory("아이템줍기코드")
sleep,1
WriteExecutableMemory("무기탈거")
sleep,1
WriteExecutableMemory("스킬사용")
sleep,1
WriteExecutableMemory("타겟스킬사용")
sleep,1
WriteExecutableMemory("타겟스킬호출")
sleep,1
WriteExecutableMemory("마법사용")
sleep,1
WriteExecutableMemory("마법호출")
sleep,1
;WriteExecutableMemory("섭팅하기코드")
WriteExecutableMemory("좌표이동")
sleep,1
WriteExecutableMemory("공격하기")
sleep,1
WriteExecutableMemory("따라가기")
sleep,1
WriteExecutableMemory("파티걸기")
sleep,1
WriteExecutableMemory("아이템줍기정지")
sleep,1
WriteExecutableMemory("퀵슬롯사용")
sleep,1
WriteExecutableMemory("몬스터주소기록함수")
sleep,1
WriteExecutableMemory("몬스터주소기록켜기")
sleep,1
WriteExecutableMemory("아이템주소기록함수")
sleep,1
WriteExecutableMemory("아이템주소기록켜기")
sleep,1
WriteExecutableMemory("플레이주소기록함수")
sleep,1
WriteExecutableMemory("플레이주소기록켜기")
sleep,1

if (게임배속사용 = 1)
{
	if ( mem.read(0x0040FB07,"Uint", aOffsets*) != 402945257 ) ; 0x180474E9
	{
		WriteExecutableMemory("게임내시간제어")
		mem.write(0x0040FB07,0xE9,"Char", aOffsets*)
		mem.write(0x0040FB08,0x74,"Char", aOffsets*)
		mem.write(0x0040FB09,0x04,"Char", aOffsets*)
		mem.write(0x0040FB0A,0x18,"Char", aOffsets*)
		mem.write(0x0040FB0B,0x00,"Char", aOffsets*)
		CheatEngine_GameSpeedTo(게임배속)
	}
}
mem.writeString(0x00590147, "물", "UTF-16", aOffsets*) ;소각할 아이템
sleep,1
mem.writeString(0x00590500, "물", "UTF-16", aOffsets*) ;은행에 넣을 아이템
sleep,1
mem.writeString(0x005901E5, "물", "UTF-16", aOffsets*) ;줍줍할 아이템
sleep,1
WriteExecutableMemory("아이템줍기실행")
sleep,1
SetFormat, Integer, H
상승어빌주소 := mem.processPatternScan(0x00000000, 0x7FFFFFFF, 0xB0, 0x62, 0x53, 0x00, 0x01, 0x03, 0x00)
guicontrol, ,상승어빌주소, %상승어빌주소%
SetFormat, Integer, D
return
;}

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

실행:
;{
if (TargetPID = "")
{
	MSGBOX, 캐릭터를 선택해 주세요.
	return
}
guicontrol,Disabled,CurrentMode
guicontrol,enable,중지
guicontrol,Disabled,실행
guicontrol,Hide,실행
guicontrol,Show,중지
Coin := True
return
;}

중지:
;{
SB_SETTEXT("사용자가 중지를 요청",2)
temp_variable := CurrentMode
Item := "CurrentMode"
guicontrol,enable,CurrentMode
GuiControl,, CurrentMode, %temp_variable%||
Temp_list := Item . "_DDLOptions"
for Index, option in %Temp_list%
{
	if (temp_variable != option)
		GuiControl,, %Item%, %option%
}
Coin := False
guicontrol,Disabled,중지
guicontrol,enable,실행
guicontrol,Hide,중지
guicontrol,Show,실행
return
;}


회복하기:
{
	gosub, 기본정보읽기
	gui, listview, NPC리스트
	Loop, % LV_GetCount()
	{
		LV_GetText(NPC_차원, A_Index, 2)
		LV_GetText(NPC_맵번호, A_Index, 4)
		LV_GetText(NPC_이름, A_Index, 5)
		LV_GetText(NPC_OID, A_Index, 6)
		if (차원 = NPC_차원 && NPC_맵번호 = 맵번호) {
			if (NPC_이름 = "홀리")
			{
				CallNPC(NPC_이름)
				sleep, 10
				keyclick("K6")
				keyclick("K6")
				keyclick("K6")
			}
		}
	}

	return
}

수리하기:
{
	if (Multiplyer = "없음" || Multiplyer < 1)
	{
		gosub, 일랜시아창크기구하기
		sleep, 2000
	}
	gosub, 기본정보읽기
	gui, listview, NPC리스트
	Loop, % LV_GetCount()
	{
		LV_GetText(NPC_차원, A_Index, 2)
		LV_GetText(NPC_맵번호, A_Index, 4)
		LV_GetText(NPC_이름, A_Index, 5)
		LV_GetText(NPC_OID, A_Index, 6)
		if (차원 = NPC_차원 && NPC_맵번호 = 맵번호) {
			if (NPC_이름 = "실루엣" || NPC_이름 = "칸느" || NPC_이름 = "셀포이" || NPC_이름 = "키아" || NPC_이름 = "카멘" )
			{
				CheatEngine_Move_Repair()
				loop, 5
				{
				NpcMenuSelection := mem.read(0x0058F0A4, "UInt", aOffset*)
				if (NpcMenuSelection = 0)
					CallNPC(NPC_이름)
				else
					break
				sleep, 100
				}

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
					else if (Check_Shop("Repair") = 0 )
						sleep, 100
				}
			}
		}
	}

	return
}

NPC대화창으로방해하는지확인:
{
	if (NPC대화창사용중 = True)
		return
	if (NPC_MSG_ADR = "없음" || NPC_MSG_ADR <1 )
		NPC_MSG_ADR := Check_NPCMsg_address()
	FormNumber := mem.read(0x0058DAD0, "UInt", 0xC, 0x10, 0x8, 0xA0)
	NPCMsg := mem.readString(NPC_MSG_ADR, 50, "UTF-16", aOffsets*)
	if(FormNumber == 40 || FormNumber == 68)
	{
		loop, 3
		{
			keyclick("K6")
			sleep, 1
		}
		FormNumber := mem.read(0x0058DAD0, "UInt", 0xC, 0x10, 0x8, 0xA0)
		NPCMsg := mem.readString(NPC_MSG_ADR, 50, "UTF-16", aOffsets*)
		IfInString,NPCMsg,님께서
		{
			SB_SetText("방해확인됨" FormNumber "-" NPCMsg ,2)
			temp:=get_NPCTalk_cordi()
			x:=temp.x - 10
			y:=temp.y + 10
			MouseClick(x,y)
			sleep, 1
			MouseClickRightButton(x,y)
		}
	}
	else if (FormNumber == 77 )
	{
		sleep, 1
		loop, 3
		{
			keyclick("K6")
			sleep, 1
		}
	}
	else if (FormNumber == 105 )
	{
		sleep, 1
		SB_SetText("방해확인됨" FormNumber "-" NPCMsg ,2)
		temp:=get_NPCTalk_cordi()
		x:=temp.x
		y:=temp.y
		ifinstring,NPCMsg,어떤 몬스터에
		{
			;FormNumber = 105
			mem.writeString(Result_Msg_Addr, "", "UTF-16", aOffsets*)
			x-=20
			y+=38
			MouseClick(x,y) ;종료
			keyclick("k6")
		}
	}
	else if (FormNumber == 93 )
	{
		sleep, 1
		temp:=get_NPCTalk_cordi()
		x:=temp.x
		y:=temp.y
		ifinstring,NPCMsg,어떤 도움을 원
		{
			;FormNumber = 93
			x-=20
			y+=20
			mem.writeString(Result_Msg_Addr, "", "UTF-16", aOffsets*)
			MouseClick(x,y)
		}
	}
	else if (FormNumber == 81 )
	{
		sleep, 1
		temp:=get_NPCTalk_cordi()
		x:=temp.x
		y:=temp.y
		ifinstring,NPCMsg,해독약을
		{
			;FormNumber = 81
			x:=temp.x
			y:=temp.y
			y+=27
			mem.writeString(Result_Msg_Addr, "", "UTF-16", aOffsets*)
			keyclick("k6")
			MouseClick(x,y)
		}
	}
	else if (FormNumber == 117 ) || ifinstring,NPCMsg,무슨 일로
	{
		sleep, 1
		temp:=get_NPCTalk_cordi()
		x:=temp.x
		y:=temp.y
		ifinstring,NPCMsg,무슨 일로
		{
			;FormNumber = 117
			keyclick("k6")
			mem.writeString(Result_Msg_Addr, "", "UTF-16", aOffsets*)
			x-=49
			y+=43
			MouseClick(x,y) ;종료
		}
		else ifinstring,NPCMsg,해독약을
		{
			;FormNumber = 81
			y+=27
			mem.writeString(Result_Msg_Addr, "", "UTF-16", aOffsets*)
			keyclick("k6")
			MouseClick(x,y)
		}
		else ifinstring,NPCMsg,빛나는결정을 얻다
		{
			;FormNumber = 77
			mem.writeString(Result_Msg_Addr, "", "UTF-16", aOffsets*)
			keyclick("k6")
		}
		else ifinstring,NPCMsg,이런 곳까지 오
		{
			;FormNumber = 77
			mem.writeString(Result_Msg_Addr, "", "UTF-16", aOffsets*)
			keyclick("k6")
			keyclick("k6")
			keyclick("k6")
		}

		else ifinstring,NPCMsg,어떤 도움을 원
		{
			;FormNumber = 93
			x-=20
			y+=20
			mem.writeString(Result_Msg_Addr, "", "UTF-16", aOffsets*)
			MouseClick(x,y)
		}
		else ifinstring,NPCMsg,이 마법은 사실
		{
			;FormNumber = 77
			mem.writeString(Result_Msg_Addr, "", "UTF-16", aOffsets*)
			keyclick("k6")
		}

		else ifinstring,NPCMsg,개인적으로
		{
			;FormNumber = 77
			mem.writeString(Result_Msg_Addr, "", "UTF-16", aOffsets*)
			keyclick("k6")
		}
		else ifinstring,NPCMsg,이 마법에
		{
			;FormNumber = 77
			mem.writeString(Result_Msg_Addr, "", "UTF-16", aOffsets*)
			keyclick("k6")
		}
		else ifinstring,NPCMsg,트렌트와
		{
			;FormNumber = 77
			mem.writeString(Result_Msg_Addr, "", "UTF-16", aOffsets*)
			keyclick("k6")
		}
		else ifinstring,NPCMsg,효과를 얻다
		{
			mem.writeString(Result_Msg_Addr, "", "UTF-16", aOffsets*)
			;FormNumber = 77
			keyclick("k6")
			도움필요 := False
		}
		else ifinstring,NPCMsg,부족합니다
		{
			mem.writeString(Result_Msg_Addr, "", "UTF-16", aOffsets*)
			;FormNumber = 77
			keyclick("k6")
			도움필요 := False
		}
		else ifinstring,NPCMsg,빛나는가루 10개를
		{
			;FormNumber = 81
			x-=16
			y+=13
			mem.writeString(Result_Msg_Addr, "", "UTF-16", aOffsets*)
			MouseClick(x,y)
			도움필요 := False
		}
		else ifinstring,NPCMsg,빛나는가루가 부족합
		{
			;FormNumber = 77
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
		else if (FormNumber=0)
		{
			mem.writeString(Result_Msg_Addr, "", "UTF-16", aOffsets*)
			keyclick("k6")
			포북대화 := False
		}

	}

	return
}

게임내지침서사용:
{
WriteExecutableMemory("기존지침서사용")
return
}

핵지침서사용:
;{
	WriteExecutableMemory("기존지침서무시")
	지침서선택:
		gui, submit, nohide
		guicontrolget, 지침서
		WriteExecutableMemory(지침서)
		return
;}

넣을아이템입력:
;{
	gui, submit, nohide
	guicontrolget,넣을아이템
	은행넣을아이템 := mem.writeString(0x00590500, 넣을아이템, "UTF-16", aOffsets*)
	return
;}

은행넣기테스트:
;{
	RunMemory("은행넣기")
	return
;}

은행빼기테스트:
;{
	RunMemory("은행빼기")
	return
;}

마법읽어오기:
;{
	그레이드필요 := False
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
		마법이름 := "마법" . A_index . "_이름"
		마법레벨 := "마법" . A_index
		Ability_name := %마법이름%
		Ability := %마법레벨%
		GuiControl,,%마법이름%, %Ability_name%
		GuiControl,,%마법레벨%, %Ability%
		if (Ability = 100)
		{
			GuiControlGet,그레이드여부,,%마법이름%
			if (그레이드여부 = 1)
			{
				그레이드필요 := True
				그레이드종류 := "마법" ; "어빌" || "마법"
				그레이드할어빌 := Ability_name
				SB_SetText(그레이드할어빌 "그레이드필요",5)
			}
		}
		For Index, skill in SpellList
		{
			if(%마법이름% = skill)
			{
				Record := True
				break
			}
		}
		if(Record = True)
		{
			임시이름 := Ability_name . "번호"
			임시번호 := A_index
			GuiControl,, %임시이름%, %임시번호%
		}
		if(마법이름 != Fail && 마법이름 != "")
			LV_Add("", "마법", A_index, Ability_name, 0, Ability)
		else
			break
	}
	return
;}


어빌리티읽어오기:
;{
	그레이드필요 := False
	A:=0
	Gui,ListView,어빌리티리스트
	LV_Delete()
	;forgui8items := ["SpellList","CommonSkillList","NormalSkillList","TargetSkillList"]

	loop,72
	{
		A := 4 * A_index
		어빌리티이름 := "어빌리티" . A_index . "_이름"
		%어빌리티이름% := mem.readString(0x0058DAD4, 50, "UTF-16", 0x178, 0xc6, 0x8, A, 0x8, 0x4)
		그레이드 := "어빌리티" . A_index . "_그레이드"
		%그레이드% := mem.read(0x0058DAD4, "UInt", 0x178, 0xc6, 0x8, A, 0x8, 0x20c)
		어빌리티 := "어빌리티" . A_index
		%어빌리티% := mem.read(0x0058DAD4, "UInt", 0x178, 0xc6, 0x8, A, 0x8, 0x208)
		Ability_name := %어빌리티이름%
		Ability_Grade := %그레이드%
		Ability := %어빌리티%
		GuiControl,,%어빌리티이름%, %Ability_name%
		GuiControl,,%그레이드%, %Ability_Grade%
		GuiControl,,%어빌리티%, %Ability%
		if (Ability = 10000)
		{
			GuiControlGet,그레이드여부,,%어빌리티이름%
			if (그레이드여부 = 1)
			{
				그레이드필요 := True
				그레이드종류 := "어빌" ; "어빌" || "마법"
				그레이드할어빌 := Ability_name
				SB_SetText(그레이드할어빌 "그레이드필요",2)
			}
		}
		어빌리티 := round(%어빌리티%/100,4)
		어빌번호 := A_index
		For Index, 어빌 in SkillListA
		{
			if(%어빌리티이름% = 어빌)
			{
				임시이름 := %어빌리티이름% . "번호"
				GuiControl,, %임시이름%, %어빌번호%
				break
			}
		}
		if(어빌리티이름 != Fail && %어빌리티이름% != "")
		{
			Gui,ListView,어빌리티리스트
			LV_Add("", "어빌", A_index, %어빌리티이름%, %그레이드%, 어빌리티)
		}
		else
			break
	}
	return
;}

;}

;-------------------------------------------------------
;-------반복성 실행 코드---------------------------------
;-------------------------------------------------------
;{

포남링교환:
;{
	Gui, Submit, nohide
	if (Multiplyer = "없음" || Multiplyer < 1)
		gosub, 일랜시아창크기구하기

	맵번호 := mem.read(0x0058EB1C, "UInt", 0x10E)
	if (맵번호 != 4002)
	{
		SB_SetText("포프레스네에서만 실행가능합니다",2)
		return
	}
	inven := mem.read(0x0058DAD4, "UInt", 0x178, 0xBE, 0x14)
	if(inven>49)
	{
		SB_SetText("인벤토리를 두칸정도 비우고 다시 시작해 주세요",2)
		return
	}
	loop,
	{
		sleep,1000
		SB_SetText("포남링교환: 리노아호출중",2)
		호출할NPC := "리노아"
		호출할NPCOID존재여부 := CallNPC(호출할NPC)
		if(호출할NPCOID존재여부 = 1)
		{
			break

		}
		else
		{
			SB_SetText("포남자사, 리노아에게 가는중",2)
			좌표입력(120,182,1)
			RunMemory("좌표이동")
			continue
		}

	}
	sleep,1000
	FormNumber := mem.read(0x0058DAD0, "UInt", 0xC, 0x10, 0x8, 0xA0)
	if(FormNumber = 85)
	{
		MouseClick(379,333)
	}

	sleep, 1000
	if ((NPC_MSG_ADR = "없음") || (NPC_MSG_ADR < 1))
	{
		sleep, 500
		SetFormat, Integer, H
		startAddress := 0x00100000
		endAddress := 0x00200000
		NPC_MSG_ADR := mem.processPatternScan(startAddress, endAddress, 0xB4, 0xC5, 0x14, 0xB5, 0xF4, 0xBC, 0x90, 0xC7, 0x2E, 0x00, 0x2E, 0x00, 0x20, 0x00) ; "어디보자" 를 검색
		SetFormat, Integer, D
		SB_SetText("NPC대화주소검색중" NPC_MSG_ADR,2)
		GuiControl,, NPC_MSG_ADR, %NPC_MSG_ADR%
		sleep, 100
	}

	if ((NPC_MSG_ADR = "없음") || (NPC_MSG_ADR < 1))
	{
		SB_SetText("NPC대화주소검색실패" NPC_MSG_ADR,2)
		return
	}
	if !(위치고정 = 1)
	{
		CheatEngine_DoNotMove()
	}
	loop, ; 링 교환
	{
		sleep, 500
		NPCMsg := mem.readString(NPC_MSG_ADR, 52, "UTF-16", aOffsets*)
		FormNumber := mem.read(0x0058DAD0, "UInt", 0xC, 0x10, 0x8, 0xA0)
		IfInString,NPCMsg,어디보자
		{
			mem.writeString(NPC_MSG_ADR, "", "UTF-16", aOffsets*)
			temp:=get_NPCTalk_cordi()
			;[아이템과 바꾼다.] 위치
			x:=temp.x - 5
			y:=temp.y - 5
			MouseClick(x,y)
			continue
		}
		else IfInString,NPCMsg,30개 받을게
		{
			temp:=get_NPCTalk_cordi()
			mem.writeString(NPC_MSG_ADR, "", "UTF-16", aOffsets*)
			;[예.] 위치
			x:=temp.x - 14
			y:=temp.y + 17
			MouseClick(x,y)
			Continue
		}
		else IfInString,NPCMsg,모자란 것
		{
			mem.writeString(NPC_MSG_ADR, "", "UTF-16", aOffsets*)
			KeyClick("K6")
			sb_settext("가루가 부족합니다! 작동을 중지합니다.",2)
			break
		}
		else IfInString,NPCMsg,미안한데 아이템은
		{
			mem.writeString(NPC_MSG_ADR, "", "UTF-16", aOffsets*)
			KeyClick("K6")
			;금일교환완료표기필요
			break
		}
		else IfInString,NPCMsg,가 나왔네
		{
			mem.writeString(NPC_MSG_ADR, "", "UTF-16", aOffsets*)
			KeyClick("K6")
			; 링기록필요
			break
		}
	}
	loop, ; 가루 교환
	{
		sleep, 500
		NPCMsg := mem.readString(NPC_MSG_ADR, 52, "UTF-16", aOffsets*)
		FormNumber := mem.read(0x0058DAD0, "UInt", 0xC, 0x10, 0x8, 0xA0)
		IfInString,NPCMsg,어디보자
		{
			mem.writeString(NPC_MSG_ADR, "", "UTF-16", aOffsets*)
			temp:=get_NPCTalk_cordi()
			;[아이템과 바꾼다.] 위치
			x:=temp.x - 5
			y:=temp.y + 7
			MouseClick(x,y)
			continue
		}
		else IfInString,NPCMsg,30개 받을게
		{
			temp:=get_NPCTalk_cordi()
			mem.writeString(NPC_MSG_ADR, "", "UTF-16", aOffsets*)
			;[예.] 위치
			x:=temp.x - 14
			y:=temp.y + 17
			MouseClick(x,y)
			Continue
		}
		else IfInString,NPCMsg,모자란 것
		{
			mem.writeString(NPC_MSG_ADR, "", "UTF-16", aOffsets*)
			KeyClick("K6")
			sb_settext("가루가 부족합니다! 작동을 중지합니다.",2)
			break
		}
		else IfInString,NPCMsg,미안한데 아이템은
		{
			mem.writeString(NPC_MSG_ADR, "", "UTF-16", aOffsets*)
			KeyClick("K6")
			;금일교환완료표기필요
			break
		}
		else IfInString,NPCMsg,실패
		{
			mem.writeString(NPC_MSG_ADR, "", "UTF-16", aOffsets*)
			KeyClick("K6")
			break
		}
		else
		{
			KeyClick("K6")
			;성공 기록
			break
		}
	}
	sleep, 1000
	NPCMsg := mem.readString(NPC_MSG_ADR, 52, "UTF-16", aOffsets*)
	FormNumber := mem.read(0x0058DAD0, "UInt", 0xC, 0x10, 0x8, 0xA0)
	IfInString,NPCMsg,어디보자
	{
		mem.writeString(NPC_MSG_ADR, "", "UTF-16", aOffsets*)
		temp:=get_NPCTalk_cordi()
		;[아이템과 바꾼다.] 위치
		x:=temp.x - 45
		y:=temp.y + 45
		MouseClick(x,y)
	}

return
;}

상인단순제작:
;{
	SB_SetText("상인단순제작",1)
	guicontrol, ,포레스트네자동대화, 0
	guicontrol, ,자동공격여부, 0
	guicontrol, ,자동이동여부, 0
	guicontrol, ,아템먹기여부, 0
	guicontrol, ,무기사용여부, 0

	gui, submit, nohide
	if !(위치고정 = 1)
	{
		CheatEngine_DoNotMove()
	}

	처음시작 := 0
	RepairCount := 1
	상승어빌 := mem.readString(상승어빌주소 + 0x64, 20, "UTF-16", aOffsets*)
	상승어빌값 := mem.read(상승어빌주소 + 0x264, "UInt", aOffsets*)
	if (상승어빌 = "미용" || 상승어빌 = "요리" || 상승어빌 = "재단" || 상승어빌 = "스미스" || 상승어빌 = "세공" || 상승어빌 = "목공" || 상승어빌 = "연금술" )
	{
		상승어빌카운트 := mem.read(상승어빌주소 + 0x264 + 0x8, "UShort", aOffsets*)
		기존어빌카운트 := 상승어빌카운트
	}
	if (Multiplyer = "없음" || Multiplyer < 1)
	{
		SB_SetText("일랜시아창크기구하기",2)
		gosub, 일랜시아창크기구하기
	}
	if (처음시작 == 0)
	{
		SB_SetText("상인단순제작처음시작세팅",2)
		인벤토리 := mem.read(0x0058DAD4, "UInt", 0x178, 0xBE, 0x14)
		if (인벤토리 >= 50)
		{
			SB_SetText("오류로 인한 중지 - 인벤토리 1칸이상 비우고 시작해"   ,2)
			CurrentMode := "대기모드"
			guicontrol, ,CurrentMode,%CurrentMode%
			return
		}
		if (Result_Msg_Addr == 0 || Result_Msg_Addr ="")
		{
			RunMemory("무기탈거")
			sleep, 100
			책좌표X := mem.read(0x0058EB48, "UInt", 0xBC)
			책좌표Y := mem.read(0x0058EB48, "UInt", 0xC0)
			수련좌표X := 책좌표X + 80
			수련좌표Y := 책좌표Y - 16
			MouseMoveTo(수련좌표X,수련좌표Y)
			sleep, 10
			MouseClick(수련좌표X,수련좌표Y)
			sleep, 10
			startAddress := 0x0F000000
			endAddress := 0x4FFFFFFF
			settimer, 스킬사용하기, off
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
			settimer, 스킬사용하기, 1000
		}
		if (Result_Msg_Addr>0)
		{
			goodtogo := 1
			처음시작 := 1
			SB_SetText("알림창 메모리위치 구하기 성공",2)
		}
		else
		{
			SB_SetText("알림창 메모리위치 구하기 실패",2)
			CurrentMode := "대기모드"
			guicontrol,,CurrentMode,%CurrentMode%
			sleep,1000
			return
		}
	}

	cookdelay := 2800
	sleep, % cookdelay
	loop,
	{
		if (CurrentMode != "상인단순제작")
			break
		sleep, 100
		Keyclick(0) ;수련키트 장착
		sleep, 100
		책좌표X := mem.read(0x0058EB48, "UInt", 0xBC)
		책좌표Y := mem.read(0x0058EB48, "UInt", 0xC0)
		수련좌표X := 책좌표X + 80
		수련좌표Y := 책좌표Y - 16
		MouseMoveTo(수련좌표X,수련좌표Y)
		sleep, 10
		MouseClick(수련좌표X,수련좌표Y)
		sleep, 100
		gosub, 넣을아이템입력
		RunMemory("은행넣기")
		SB_SetText("은행넣기" RepairCount ,1)
		loop,  ; 0.05초마다 결과 확인
		{
			if (CurrentMode != "상인단순제작")
				break
			Read_Result_MSG := mem.readString(Result_Msg_Addr, 50, "UTF-16", aOffsets*)
			ifinstring, Read_Result_MSG, 실패했습니다주세요.
			{
				delay := delay + 100
				RunMemory("은행빼기")
				sleep, 2000
				Write_Result_MSG := mem.writeString(Result_Msg_Addr, "", "UTF-16", aOffsets*)
				MouseClick(수련좌표X,수련좌표Y)
				sleep, 100
				RunMemory("은행넣기")
				SB_SetText("은행넣기" ,1)
				SB_SetText("delay를 " delay " 로 재설정"   ,1)
			}
			else
			{
				break
			}
			sleep, 50
		}
		if (CurrentMode != "상인단순제작")
			break

		Count_A := 0
		Current_time := A_TickCount
		sleep, 1000
		loop,  ; 0.5초마다 결과 확인
		{
			if (CurrentMode != "상인단순제작")
				break
			상승어빌 := mem.readString(상승어빌주소 + 0x64, 20, "UTF-16", aOffsets*)
			상승어빌값 := mem.read(상승어빌주소 + 0x264, "UInt", aOffsets*)
			guicontrol, ,상승어빌, %상승어빌%
			IfInString, 상승어빌, 연금술
			상승어빌 := "연금술"
			IfInString, 상승어빌, 스미스
			상승어빌 := "스미스"
			Read_Result_MSG := mem.readString(Result_Msg_Addr, 50, "UTF-16", aOffsets*)
			sb_settext(Read_Result_MSG,2)
			if (상승어빌 = "연금술" || 상승어빌 = "미용" || 상승어빌 = "요리" || 상승어빌 = "재단" || 상승어빌 = "스미스" || 상승어빌 = "세공" || 상승어빌 = "목공" )
			{
				상승어빌카운트 := mem.read(상승어빌주소 + 0x264 + 0x8, "UShort", aOffsets*)
				필요어빌카운트 := mem.read(상승어빌주소 + 0x264 + 0xA, "UShort", aOffsets*)
				if (기존어빌카운트 != 상승어빌카운트)
				{
					올른카운트 := 상승어빌카운트 - 기존어빌카운트 + 필요어빌카운트 * (상승어빌값 - 기존어빌)
					기존어빌카운트 := 상승어빌카운트
					기존어빌 := 상승어빌값
					sb_settext(상승어빌 "(" Round(상승어빌값 / 100,2) " - " 상승어빌카운트 "/" 필요어빌카운트 ") " 올른카운트 "카운트 상승"  ,2)
					break
				}
			}
			else ifinstring, Read_Result_MSG,에 성공
			{
				Write_Result_MSG := mem.writeString(Result_Msg_Addr, "", "UTF-16", aOffsets*)
				break
			}
			else ifinstring, Read_Result_MSG,실패
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

		if (CurrentMode != "상인단순제작")
			break
		RunMemory("은행빼기")
		SB_SetText("은행빼기" ,1)
		if (RepairCount == 1)
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
;}

상인어빌수련:
;{
	SB_SetText("상인어빌수련",1)
	guicontrol, ,포레스트네자동대화, 0
	guicontrol, ,자동공격여부, 0
	guicontrol, ,자동이동여부, 0
	guicontrol, ,아템먹기여부, 0
	guicontrol, ,무기사용여부, 0

	gui, submit, nohide
	if !(위치고정 = 1)
	{
		CheatEngine_DoNotMove()
	}

	처음시작 := 0
	RepairCount := 1
	상승어빌 := mem.readString(상승어빌주소 + 0x64, 20, "UTF-16", aOffsets*)
	상승어빌값 := mem.read(상승어빌주소 + 0x264, "UInt", aOffsets*)
	if (상승어빌 = "미용" || 상승어빌 = "요리" || 상승어빌 = "재단" || 상승어빌 = "스미스" || 상승어빌 = "세공" || 상승어빌 = "목공" || 상승어빌 = "연금술" )
	{
		상승어빌카운트 := mem.read(상승어빌주소 + 0x264 + 0x8, "UShort", aOffsets*)
		기존어빌카운트 := 상승어빌카운트
	}
	if (Multiplyer = "없음" || Multiplyer < 1)
	{
		SB_SetText("일랜시아창크기구하기",2)
		gosub, 일랜시아창크기구하기
	}
	if (처음시작 == 0)
	{
		SB_SetText("상인어빌수련처음시작세팅",2)
		인벤토리 := mem.read(0x0058DAD4, "UInt", 0x178, 0xBE, 0x14)
		if (인벤토리 >= 50)
		{
			SB_SetText("오류로 인한 중지 - 인벤토리 1칸이상 비우고 시작해"   ,2)
			CurrentMode := "대기모드"
			guicontrol, ,CurrentMode,%CurrentMode%
			return
		}
		if (Result_Msg_Addr == 0 || Result_Msg_Addr ="")
		{
			RunMemory("무기탈거")
			sleep, 100
			책좌표X := mem.read(0x0058EB48, "UInt", 0xBC)
			책좌표Y := mem.read(0x0058EB48, "UInt", 0xC0)
			수련좌표X := 책좌표X + 80
			수련좌표Y := 책좌표Y - 16
			MouseMoveTo(수련좌표X,수련좌표Y)
			sleep, 10
			MouseClick(수련좌표X,수련좌표Y)
			sleep, 10
			startAddress := 0x0F000000
			endAddress := 0x4FFFFFFF
			settimer, 스킬사용하기, off
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
			settimer, 스킬사용하기, 1000
		}
		if (Result_Msg_Addr>0)
		{
			goodtogo := 1
			처음시작 := 1
			SB_SetText("알림창 메모리위치 구하기 성공",2)
		}
		else
		{
			SB_SetText("알림창 메모리위치 구하기 실패",2)
			CurrentMode := "대기모드"
			guicontrol,,CurrentMode,%CurrentMode%
			sleep,1000
			return
		}
	}
	if (처음시작 == 1 || 처음시작 == 0)
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
			}
			else if (abillity_name = "요리")
			{
				요리어빌 := abillity
				요리제한 := (Floor(요리어빌 / 10) + 1) * 10
			}
			else if (abillity_name = "재단")
			{
				재단어빌 := abillity
				재단제한 := (Floor(재단어빌 / 10) + 1) * 10
			}
			else if (abillity_name = "세공")
			{
				세공어빌 := abillity
				세공제한 := (Floor(세공어빌 / 10) + 1) * 10
			}
			else if (abillity_name = "스미스")
			{
				스미스어빌 := abillity
				스미스제한 := (Floor(스미스어빌 / 10) + 1) * 10
			}
			else if (abillity_name = "목공")
			{
				목공어빌 := abillity
				목공제한 := (Floor(목공어빌 / 10) + 1) * 10
			}
			else if (abillity_name = "연금술")
			{
				연금술어빌 := abillity
				연금술제한 := (Floor(연금술어빌 / 10) + 1) * 10
			}
		}
	}
	cookdelay := 2800
	sleep, % cookdelay
	loop,
	{
		if (CurrentMode != "상인어빌수련")
			break
		sleep, 100
		Keyclick(0) ;수련키트 장착
		sleep, 100
		책좌표X := mem.read(0x0058EB48, "UInt", 0xBC)
		책좌표Y := mem.read(0x0058EB48, "UInt", 0xC0)
		수련좌표X := 책좌표X + 80
		수련좌표Y := 책좌표Y - 16
		MouseMoveTo(수련좌표X,수련좌표Y)
		sleep, 10
		MouseClick(수련좌표X,수련좌표Y)
		sleep, 100
		gosub, 넣을아이템입력
		RunMemory("은행넣기")
		SB_SetText("은행넣기" RepairCount ,1)
		loop,  ; 0.05초마다 결과 확인
		{
			if (CurrentMode != "상인어빌수련")
				break
			Read_Result_MSG := mem.readString(Result_Msg_Addr, 50, "UTF-16", aOffsets*)
			ifinstring, Read_Result_MSG, 실패했습니다주세요.
			{
				delay := delay + 100
				RunMemory("은행빼기")
				sleep, 2000
				Write_Result_MSG := mem.writeString(Result_Msg_Addr, "", "UTF-16", aOffsets*)
				MouseClick(수련좌표X,수련좌표Y)
				sleep, 100
				RunMemory("은행넣기")
				SB_SetText("은행넣기" ,1)
				SB_SetText("delay를 " delay " 로 재설정"   ,1)
			}
			else
			{
				break
			}
			sleep, 50
		}
		if (CurrentMode != "상인어빌수련")
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
				{
					SB_SetText(abillity_name "어빌" 미용제한 "달성, 대기" ,2)
					gosub,CurrentMode_대기모드
				}
			}
			else if (abillity_name = "요리")
			{
				요리어빌 := abillity
				if (요리어빌 >= 요리제한)
				{
					SB_SetText(abillity_name "어빌" 요리제한 "달성, 대기" ,2)
					gosub,CurrentMode_대기모드
				}
			}
			else if (abillity_name = "재단")
			{
				재단어빌 := abillity
				if (재단어빌 >= 재단제한)
				{
					SB_SetText(abillity_name "어빌" 재단제한 "달성, 대기" ,2)
					gosub,CurrentMode_대기모드
				}
			}
			else if (abillity_name = "세공")
			{
				세공어빌 := abillity
				if (세공어빌 >= 세공제한)
				{
					SB_SetText(abillity_name "어빌" 세공제한 "달성, 대기" ,2)
					gosub,CurrentMode_대기모드
				}
			}
			else if (abillity_name = "스미스")
			{
				스미스어빌 := abillity
				if (스미스어빌 >= 스미스제한)
				{
					SB_SetText(abillity_name "어빌" 스미스제한 "달성, 대기" ,2)
					gosub,CurrentMode_대기모드
				}
			}
			else if (abillity_name = "목공")
			{
				목공어빌 := abillity
				if (목공어빌 >= 목공제한)
				{
					SB_SetText(abillity_name "어빌" 목공제한 "달성, 대기" ,2)
					gosub,CurrentMode_대기모드
				}
			}
			else if (abillity_name = "연금술")
			{
				연금술어빌 := abillity
				if (연금술어빌 >= 연금술제한)
				{
					SB_SetText(abillity_name "어빌" 연금술제한 "달성, 대기" ,2)
					gosub,CurrentMode_대기모드
				}
			}
		}
		Count_A := 0
		Current_time := A_TickCount
		sleep, 1000
		Keyclick(9) ;키아키트 장착
		SB_SetText("키아키트 장착" ,1)
		loop,  ; 0.5초마다 결과 확인
		{
			if (CurrentMode != "상인어빌수련")
				break
			상승어빌 := mem.readString(상승어빌주소 + 0x64, 20, "UTF-16", aOffsets*)
			상승어빌값 := mem.read(상승어빌주소 + 0x264, "UInt", aOffsets*)
			guicontrol, ,상승어빌, %상승어빌%
			IfInString, 상승어빌, 연금술
			상승어빌 := "연금술"
			IfInString, 상승어빌, 스미스
			상승어빌 := "스미스"
			if (상승어빌 = "연금술" || 상승어빌 = "미용" || 상승어빌 = "요리" || 상승어빌 = "재단" || 상승어빌 = "스미스" || 상승어빌 = "세공" || 상승어빌 = "목공" )
			{
				상승어빌카운트 := mem.read(상승어빌주소 + 0x264 + 0x8, "UShort", aOffsets*)
				필요어빌카운트 := mem.read(상승어빌주소 + 0x264 + 0xA, "UShort", aOffsets*)
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

		if (CurrentMode != "상인어빌수련")
			break
		RunMemory("은행빼기")
		SB_SetText("은행빼기" ,1)
		if (RepairCount == 1)
		{
			settimer, 스킬사용하기, off

			SetTimer, 나프마통작, off
			gosub, 수리하기
			RepairCount := 300
			SB_SetText("수리완료"  ,1)
			sleep, 500
			settimer, 스킬사용하기, 1000
			if (나프사용 = 1)
				SetTimer, 나프마통작, 300
		}
		RepairCount -= 1
		sleep, %cookdelay%

	}
	return
;}

리스무기구매:
;{

return
;}

행깃구매:
;{

return
;}

행깃교환:
;{

return
;}

길탐수련:
;{
	Gui, Submit, nohide
	if !(위치고정 = 1)
	{
		CheatEngine_DoNotMove()
	}
	CheatEngine_Buy_Unlimitted()
	시작인벤토리 := mem.read(0x0058DAD4, "UInt", 0x178, 0xBE, 0x14) - floor((아이템갯수["식빵"]+49)/50)
	if 수련길탐딜레이 = 1
	{
		GuiControlGet, 수련용길탐색딜레이
	}
	else
	{
		수련용길탐색딜레이 := 1000
	}
	loop,
	{
		if (CurrentMode != "길탐수련")
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
		if (아이템갯수["식빵"] = "") && (GALRID < 1000) ;갈리드가 1000이하면 빠꾸
		{
			SB_SetText("소지금액부족",2)
			break
		}
		else if (아이템갯수["식빵"] = "") || (시작인벤토리 >= 현재인벤토리) ;식빵이 0개면 식빵 구매하기
		{
			SB_SetText("식빵구매 NPC호출중",2)
			if (맵번호 == 204)
			{
				NPC이름 := "카딜라"
			}
			else if (맵번호 == 1200)
			{
				NPC이름 := ""
			}
			else if (맵번호 == 2200)
			{
				NPC이름 := ""
			}
			else if (맵번호 == 3200)
			{
				NPC이름 := ""
			}
			else if (맵번호 == 4200)
			{
				NPC이름 := "쿠키"
			}
			loop, 5
			{
				NpcMenuSelection := mem.read(0x0058F0A4, "UInt", aOffset*)
				if (NpcMenuSelection == 0)
					CallNPC(NPC이름)
				else
				{
					SB_SetText("식빵구매 NPC호출성공",2)
					break
				}
				sleep, 100
			}
			loop, 5
			{
				NPCMENUSELECT("Buy")
				sleep, 100
				if (Check_Shop("Buy")!=0)
				{
					SB_SetText("식빵구매창 호출성공",2)
					break
				}
			}
			NPC거래창첫번째메뉴클릭()
			쿠키28 := "식빵"
			카딜라38:="치즈"
			카딜라40:="식빵"

			loop, 41
			{
				if (CurrentMode != "길탐수련")
					break
				target := NPC이름 . A_Index
				target := %target%
				if (target = "식빵") || (target = "치즈")
				{
					keyclick("K1")
					keyclick("K0")
					keyclick("K0")
					break
				}
				keyclick("DownArrow")
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
			상승어빌 := mem.readString(상승어빌주소 + 0x64, 20, "UTF-16", aOffsets*)
			상승어빌값 := mem.read(상승어빌주소 + 0x264, "UInt", aOffsets*)
			if (상승어빌 = "길탐색")
			{
				상승어빌카운트 := mem.read(상승어빌주소 + 0x264 + 0x8, "UShort", aOffsets*)
				필요어빌카운트 := mem.read(상승어빌주소 + 0x264 + 0xA, "UShort", aOffsets*)
				if (%상승어빌%기존어빌카운트 != 상승어빌카운트)
				{
					올른카운트 := 상승어빌카운트 - %상승어빌%기존어빌카운트 + 필요어빌카운트 * (상승어빌값 - %상승어빌%기존어빌)
					%상승어빌%기존어빌카운트 := 상승어빌카운트
					%상승어빌%기존어빌 := 상승어빌값
					;sb_settext(상승어빌 "(" Round(상승어빌값 / 100,2) " - " 상승어빌카운트 "/" 필요어빌카운트 ") " 올른카운트 "카운트 상승"  ,2)
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
;}

;}

;-------------------------------------------------------
;-------사용자 인터페이스 입력 처리-----------------------
;-------------------------------------------------------
;{

CurrentMode_대기모드:
;{
CurrentMode := "대기모드"
Item := "CurrentMode"
temp_variable := CurrentMode
Control, ChooseString, %Item%, %temp_variable%
GuiControl,, %Item%, |
GuiControl,, %Item%, %temp_variable%||
Temp_list := Item . "_DDLOptions"
for Index, option in %Temp_list%
{
	if (temp_variable != option)
		GuiControl,, %Item%, %option%
}
return
;}

CurrentMode_행깃구매:
;{
SB_SETTEXT("사용자가 행깃구매를 요청",2)
CurrentMode := "행깃구매"
Item := "CurrentMode"
temp_variable := CurrentMode
Control, ChooseString, %Item%, %temp_variable%
GuiControl,, %Item%, |
GuiControl,, %Item%, %temp_variable%||
Temp_list := Item . "_DDLOptions"
for Index, option in %Temp_list%
{
	if (temp_variable != option)
		GuiControl,, %Item%, %option%
}
return
;}

CurrentMode_행깃교환:
;{
SB_SETTEXT("사용자가 행깃구매를 요청",2)
CurrentMode := "행깃교환"
Item := "CurrentMode"
temp_variable := CurrentMode
Control, ChooseString, %Item%, %temp_variable%
GuiControl,, %Item%, |
GuiControl,, %Item%, %temp_variable%||
Temp_list := Item . "_DDLOptions"
for Index, option in %Temp_list%
{
	if (temp_variable != option)
		GuiControl,, %Item%, %option%
}
return
;}

CurrentMode_상인어빌수련:
;{
SB_SETTEXT("상인어빌수련 시작",2)
gui,submit,nohide
Item := "CurrentMode"
temp_variable := "상인어빌수련"
Control, ChooseString, %Item%, %temp_variable%
GuiControl,, %Item%, |
GuiControl,, %Item%, %temp_variable%||
Temp_list := Item . "_DDLOptions"
for Index, option in %Temp_list%
{
	if (temp_variable != option)
		GuiControl,, %Item%, %option%
}
gosub, 실행
return
;}

CurrentMode_상인단순제작:
;{
SB_SETTEXT("상인단순제작 시작",2)
gui,submit,nohide
Item := "CurrentMode"
temp_variable := "상인단순제작"
Control, ChooseString, %Item%, %temp_variable%
GuiControl,, %Item%, |
GuiControl,, %Item%, %temp_variable%||
Temp_list := Item . "_DDLOptions"
for Index, option in %Temp_list%
{
	if (temp_variable != option)
		GuiControl,, %Item%, %option%
}
gosub, 실행
return
;}

CurrentMode_길탐수련:
;{
SB_SETTEXT("길탐수련 시작",2)
gui,submit,nohide
Item := "CurrentMode"
temp_variable := "길탐수련"
Control, ChooseString, %Item%, %temp_variable%
GuiControl,, %Item%, |
GuiControl,, %Item%, %temp_variable%||
Temp_list := Item . "_DDLOptions"
for Index, option in %Temp_list%
{
	if (temp_variable != option)
		GuiControl,, %Item%, %option%
}
gosub, 실행
return
;}

사용자선택:
{
global 주먹사용여부
global 사용할무기수량
Gui, Submit, nohide

if (이동속도사용 = 1)
{
	CheatEngine_MoveSpeedTo(MoveSpeed)
}
if (게임배속사용 = 1)
{
	if ( mem.read(0x0040FB07,"Uint", aOffsets*) != 402945257 ) ; 0x180474E9
	{
		WriteExecutableMemory("게임내시간제어")
		mem.write(0x0040FB07,0xE9,"Char", aOffsets*)
		mem.write(0x0040FB08,0x74,"Char", aOffsets*)
		mem.write(0x0040FB09,0x04,"Char", aOffsets*)
		mem.write(0x0040FB0A,0x18,"Char", aOffsets*)
		mem.write(0x0040FB0B,0x00,"Char", aOffsets*)
	}
	CheatEngine_GameSpeedTo(게임배속)
}
if (차원결정유지 = 1)
{
	Dimension := mem.read(0x0058EB1C, "UInt", 0x10A)
	if(Dimension>20000)
		목적차원 := "감마"
	else if(Dimension>10000)
		목적차원 := "베타"
	else if(Dimension<10000)
		목적차원 := "알파"
}
else if (차원결정알파 = 1)
{
	목적차원 := "알파"
}
else if (차원결정베타 = 1)
{
	목적차원 := "베타"
}
else if (차원결정감마 = 1)
{
	목적차원 := "감마"
}

if (퍼펙트 = 1)
	CheatEngine_AttackAlwaysPerFect()
else if (일반 = 1)
	CheatEngine_AttackAlwaysNormal()
else if (미스 = 1)
	CheatEngine_AttackAlwaysMiss()

if (위치고정 = 1)
{
	CheatEngine_DoNotMove()
}
else
{
	CheatEngine_CancelDoNotMove()
}
if (배경제거 = 1)
{
	CheatEngine_NoShowBack()
	CheatEngine_NoShowBlock()
}
else
{
	CheatEngine_ShowBack()
	CheatEngine_ShowBlock()
}
if (제작이동 = 1)
{
	CheatEngine_NoLimitMovementDuringCook()
}
else
{
	CheatEngine_CancelNoLimitMovementDuringCook()
}

if (캐릭제거 = 1)
{
	CheatEngine_NoShowChar()
}else
{
	CheatEngine_ShowChar()
}

if (주먹 = 1)
{
	CancelTwoWeaponChangeAndPunch()
	주먹사용여부 := 1
	사용할무기수량 := 0
	SB_setText("주먹",1)
}
else if (일무기 = 1)
{
	CancelTwoWeaponChangeAndPunch()
	주먹사용여부 := 0
	사용할무기수량 := 1
	SB_setText("일무기",1)
}
else if (이벗무바 = 1)
{
	TwoWeaponChangeAndPunch()
	사용할무기수량 := 2
	주먹사용여부 := 1
	SB_setText("이벗무바",1)
}
return
}

NPC리스트실행:
;{
	gui,listview,NPC리스트
	RN:=LV_GetNext(0)
	if (RN=0)
		return
	Row := A_EventInfo
	LV_GetText(C1,row,1)
	LV_GetText(C2,row,2)
	LV_GetText(C3,row,3)
	LV_GetText(C4,row,4)
	LV_GetText(C5,row,5)
	LV_GetText(C6,row,6)
	LV_GetText(C7,row,7)
	LV_GetText(C8,row,8)
	LV_GetText(C9,row,9)

	if A_GuiEvent = DoubleClick
	{
		gosub, 기본정보읽기
		CheckIfMyNPC := TargetTitle . "의"
		ifinstring, C5, %CheckIfMyNPC%
		{
			distanceX := Abs(C7 - 좌표X)
			distanceY := Abs(C8 - 좌표Y)
			if (distanceX > 16 || distanceY > 7)
				return
		}

		if (C2 = 차원 && C4 = 맵번호)
		{
			WriteExecutableMemory("NPC호출용1")
			WriteExecutableMemory("NPC호출용2")
			mem.write(0x00527b54, C6, "UInt", aOffset*)
			sleep, 50
			RunMemory("NPC호출")
			return
		}
	}
	if A_GuiEvent = click
	{
		return
	}
	if A_GuiEvent = Rightclick
		return

	return
;}
고용상인리스트실행:
;{
	gui,listview,고용상인리스트
	RN:=LV_GetNext(0)
	if (RN=0)
		return
	Row := A_EventInfo
	LV_GetText(C1,row,1)
	LV_GetText(C2,row,2)
	LV_GetText(C3,row,3)
	LV_GetText(C4,row,4)
	LV_GetText(C5,row,5)
	LV_GetText(C6,row,6)
	LV_GetText(C7,row,7)
	LV_GetText(C8,row,8)
	LV_GetText(C9,row,9)

	if A_GuiEvent = DoubleClick
	{
		gosub, 기본정보읽기
		CheckIfMyNPC := TargetTitle . "의"
		ifinstring, C5, %CheckIfMyNPC%
		{
			distanceX := Abs(C7 - 좌표X)
			distanceY := Abs(C8 - 좌표Y)
			if (distanceX > 16 || distanceY > 7)
				return
		}

		if (C2 = 차원 && C4 = 맵번호)
		{
			WriteExecutableMemory("NPC호출용1")
			WriteExecutableMemory("NPC호출용2")
			mem.write(0x00527b54, C6, "UInt", aOffset*)
			sleep, 50
			RunMemory("NPC호출")
			return
		}
	}
	if A_GuiEvent = click
	{
		return
	}
	if A_GuiEvent = Rightclick
		return

	return
;}

NPC리스트다운:
{
DownloadOID()
type:="NPC리스트"
Gui, ListView, NPC리스트
LV_Delete()
Setting_Reload(type)
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
인벤토리 := mem.read(0x0058DAD4, "UInt", 0x178, 0xBE, 0x14)
if !(인벤토리 > 0 && 인벤토리 <= 50)
{
	STOPSIGN := true
	SB_SetText("비정상",4)
	서버상태 := False
	return
}
else
{
	서버상태 := True
}
I_Delay := A_TickCount - 소지아이템리스트업데이트딜레이
if (I_Delay > 1000)
{
	SETFORMAT, integer, D
	소지아이템리스트업데이트딜레이 := A_TickCount
	invenslot := 0
	아이템갯수 := {}
	loop, 50
	{
		invenslot += 4
		invenitem := mem.readString(0x0058DAD4, 50, "UTF-16", 0x178, 0xBE, 0x8, invenslot, 0x8, 0x8, 0x0)
		ItemCount := mem.read(0x0058DAD4, "Uint", 0x178, 0xBE, 0x8, invenslot, 0x8, 0x20)
		if (invenitem = "")
			continue
		아이템갯수[invenitem] := (아이템갯수[invenitem] ? 아이템갯수[invenitem] + ItemCount : ItemCount)
		gui, listview, 은행넣을아이템리스트
		Loop % LV_GetCount()
		{
			LV_GetText(아이템,A_index,1)
			if (아이템 != "") && InStr(invenitem, 아이템) ;ifinstring, invenitem, %아이템%
			{
				add_은행넣을아이템대기리스트(invenitem)
				continue
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
				continue
			}
		}
	}
	라스의깃갯수 := 아이템갯수["라스의깃"]
	GuiControl,, 라스의깃수량, %라스의깃갯수%
	정령의보석갯수 := 아이템갯수["정령의보석"]
	GuiControl,, 정령의보석수량, %정령의보석갯수%
	식빵갯수 := 아이템갯수["정령의보석"]
	GuiControl,, 식빵수량, %식빵갯수%
	if (아이템갯수["독성포자해독약"] > 9)
		add_소각할아이템대기리스트("독성포자해독약")
	GuiControl, -Redraw, 소지아이템리스트

	gui, listview, 소지아이템리스트
	LV_Delete()

	; 연관 배열을 사용하여 리스트뷰에 아이템과 갯수를 추가
	for 아이템, 갯수 in 아이템갯수
	{
		LV_Add("", 아이템, 갯수)
	}

	GuiControl, +Redraw, 소지아이템리스트
}
return
}

원하는몬스터추가:
{
	Gui, Submit, Nohide
	type := "원하는몬스터리스트"
	Setting_RECORD(type,원하는몬스터추가할몬스터명)
	Gui, ListView, 원하는몬스터리스트
	LV_Delete()
	Setting_Reload(type)
	RowCount := LV_GetCount()
	WantedMonsters := []
	Loop, %RowCount%
	{
		LV_GetText(row,A_Index,1)
		WantedMonsters.Push(row)  ; Add the current row's array to the main ListViewItems array
	}
	WantedMonsterlength := WantedMonsters.MaxIndex()
	SB_SetText("현재원하는몬스터숫자:" WantedMonsterlength,2)
	return
}

원하는몬스터삭제:
{
    Gui, Submit, Nohide
    gui, listview, 원하는몬스터리스트
    SelectedRows := []
    RowNumber = 0
	Loop
	{
		RowNumber := LV_GetNext(RowNumber)
		if not RowNumber
			break
		SelectedRows.Push(RowNumber)
	}

    ; 선택된 행을 역순으로 순회하며 삭제
    Loop, % SelectedRows.Length()
    {
        Index := SelectedRows.MaxIndex() - A_Index + 1
        RowNumber := SelectedRows[Index]
        LV_GetText(targetItem, RowNumber)
        Setting_DELETE("원하는몬스터리스트", targetItem)
        LV_Delete(RowNumber)
        SB_SetText(targetItem " 삭제", 2)
    }

    ; 리스트 뷰 업데이트
    WantedMonsters := []
    Loop, LV_GetCount()
    {
        LV_GetText(row, A_Index, 1)
        WantedMonsters.Push(row)
    }
    WantedMonsterlength := WantedMonsters.MaxIndex()
    return
}

원하지않는몬스터추가:
{
	Gui, Submit, Nohide
	type := "원하지않는몬스터리스트"
	Setting_RECORD(type,원하지않는몬스터추가할몬스터명)
	Gui, ListView, 원하지않는몬스터리스트
	LV_Delete()
	Setting_Reload(type)
	RowCount := LV_GetCount()
	DisWantedMonsters := []
	Loop, %RowCount%
	{
		LV_GetText(row,A_Index,1)
		DisWantedMonsters.Push(row)  ; Add the current row's array to the main ListViewItems array
	}

	return
}

원하지않는몬스터삭제:
{
    Gui, Submit, Nohide
    gui, listview, 원하지않는몬스터리스트
    SelectedRows := []
    RowNumber = 0
	Loop
	{
		RowNumber := LV_GetNext(RowNumber)
		if not RowNumber
			break
		SelectedRows.Push(RowNumber)
	}

    ; 선택된 행을 역순으로 순회하며 삭제
    Loop, % SelectedRows.Length()
    {
        Index := SelectedRows.MaxIndex() - A_Index + 1
        RowNumber := SelectedRows[Index]
        LV_GetText(targetItem, RowNumber)
        Setting_DELETE("원하지않는몬스터리스트", targetItem)
        LV_Delete(RowNumber)
        SB_SetText(targetItem " 삭제", 2)
    }

    ; 리스트 뷰 업데이트
    DisWantedMonsters := []
    Loop, LV_GetCount()
    {
        LV_GetText(row, A_Index, 1)
        DisWantedMonsters.Push(row)
    }
    return
}

원하는아이템넣을아이템추가:
{
	Gui, Submit, Nohide
	type := "원하는아이템리스트"
	if (원하는아이템추가할아이템명 = "")
		return
	Setting_RECORD(type,원하는아이템추가할아이템명)
	Gui, ListView, 원하는아이템리스트
	LV_Delete()
	Setting_Reload(type)
	RowCount := LV_GetCount()
	WantedItems := []
	Loop, %RowCount%
	{
		LV_GetText(row,A_Index,1)
		WantedItems.Push(row)  ; Add the current row's array to the main ListViewItems array
	}
	WantedItemlength := WantedItems.MaxIndex()
	return
}

원하는아이템넣을아이템삭제:
{
    Gui, Submit, Nohide
    gui, listview, 원하는아이템리스트
    SelectedRows := []
    RowNumber = 0
	Loop
	{
		RowNumber := LV_GetNext(RowNumber)
		if not RowNumber
			break
		SelectedRows.Push(RowNumber)
	}

    ; 선택된 행을 역순으로 순회하며 삭제
    Loop, % SelectedRows.Length()
    {
        Index := SelectedRows.MaxIndex() - A_Index + 1
        RowNumber := SelectedRows[Index]
        LV_GetText(targetItem, RowNumber)
        Setting_DELETE("원하는아이템리스트", targetItem)
        LV_Delete(RowNumber)
        SB_SetText(targetItem " 삭제", 2)
    }

    ; 리스트 뷰 업데이트
    WantedItems := []
    Loop, LV_GetCount()
    {
        LV_GetText(row, A_Index, 1)
        WantedItems.Push(row)
    }
    WantedItemLength := WantedItems.MaxIndex()
    return
}

은행넣을아이템추가:
{
Gui, Submit, Nohide
type := "은행넣을아이템리스트"
Setting_RECORD(type,은행넣기추가할아이템명)
Gui, ListView, 은행넣을아이템리스트
LV_Delete()
Setting_Reload(type)
return
}

은행넣을아이템삭제:
{
    Gui, Submit, Nohide
    gui, listview, 은행넣을아이템리스트
    SelectedRows := []
    RowNumber = 0
	Loop
	{
		RowNumber := LV_GetNext(RowNumber)
		if not RowNumber
			break
		SelectedRows.Push(RowNumber)
	}

    ; 선택된 행을 역순으로 순회하며 삭제
    Loop, % SelectedRows.Length()
    {
        Index := SelectedRows.MaxIndex() - A_Index + 1
        RowNumber := SelectedRows[Index]
        LV_GetText(targetItem, RowNumber)
        Setting_DELETE("은행넣을아이템리스트", targetItem)
        LV_Delete(RowNumber)
        SB_SetText(targetItem " 삭제", 2)
    }
    return
}

소각할아이템추가:
{
Gui, Submit, Nohide
type := "소각할아이템리스트"
Setting_RECORD(type,소각하기추가할아이템명)
Gui, ListView, 소각할아이템리스트
LV_Delete()
Setting_Reload(type)
return
}

소각할아이템삭제:
{
    Gui, Submit, Nohide
    gui, listview, 소각할아이템리스트
    SelectedRows := []
    RowNumber = 0
	Loop
	{
		RowNumber := LV_GetNext(RowNumber)
		if not RowNumber
			break
		SelectedRows.Push(RowNumber)
	}

    ; 선택된 행을 역순으로 순회하며 삭제
    Loop, % SelectedRows.Length()
    {
        Index := SelectedRows.MaxIndex() - A_Index + 1
        RowNumber := SelectedRows[Index]
        LV_GetText(targetItem, RowNumber)
        Setting_DELETE("소각할아이템리스트", targetItem)
        LV_Delete(RowNumber)
        SB_SetText(targetItem " 삭제", 2)
    }
    return
}

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
gosub, 기본정보읽기
Setting_RECORD("좌표리스트",좌표X,좌표Y,좌표Z)
Gui, listview, 좌표리스트
LV_Delete()
Setting_Reload("좌표리스트")
return
}

좌표리스트_DO:
{
gui, listview, 좌표리스트
If (A_ThisMenuItem = "이동하기")
gosub,좌표리스트_이동하기
If (A_ThisMenuItem = "수정하기")
gosub,좌표리스트_수정하기
If (A_ThisMenuItem = "삭제하기")
gosub,좌표리스트_삭제하기
return
}

좌표리스트_이동하기:
{
좌표입력(E4,E5,E6)
sleep,30
RunMemory("좌표이동")
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
Setting_DELETE("좌표리스트", Mapnumber, MapName, x, y, z)
gui,listview,좌표리스트
Lv_Delete()
Setting_Reload("좌표리스트")
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
RunMemory("파티걸기")
return
}

목표리스트_섭팅하기:
{
mem.write(0x00590B08, C6, "UInt", aOffsets*)
RunMemory("섭팅하기")
return
}

목표리스트_따라가기:
{
mem.write(0x00590770, C6, "UInt", aOffsets*)
RunMemory("따라가기")
return
}

목표리스트_공격하기:
{
mem.write(0x00590730, C6, "UInt", aOffsets*)
RunMemory("공격하기")
return
}

목표리스트_이동하기:
{
좌표입력(C7,C8,C9)
sleep,30
RunMemory("좌표이동")
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
RunMemory("따라가기")
return
}

블랙리스트_공격하기:
{
mem.write(0x00590730, C6, "UInt", aOffsets*)
RunMemory("공격하기")
return
}

블랙리스트_이동하기:
{
좌표입력(C7,C8,C9)
sleep,30
RunMemory("좌표이동")
return
}

블랙리스트_파티하기:
{
mem.write(0x0058FE20, C6, "UInt", aOffsets*)
RunMemory("파티걸기")
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
;}

;}

기본정보읽기:
;{
	gui, submit, nohide
	인벤토리 := mem.read(0x0058DAD4, "UInt", 0x178, 0xBE, 0x14)
	if !(인벤토리 > 0 && 인벤토리 <= 50)
	{
		SB_SetText("비정상",4)
		STOPSIGN := true
		서버상태 := false
		return
	}

	맵번호 := mem.read(0x0058EB1C, "UInt", 0x10E)
	맵이름 := mem.readString(mem.getModuleBaseAddress("jelancia_core.dll")+0x44A28, 50, "UTF-16", 0xC)

	Dimension := mem.read(0x0058EB1C, "UInt", 0x10A)
	if(Dimension>20000)
		차원:="감마"
	else if(Dimension>10000)
		차원:="베타"
	else if(Dimension<10000)
		차원:="알파"

	좌표X := mem.read(0x0058DAD4, "UInt", 0x10)
	좌표Y := mem.read(0x0058DAD4, "UInt", 0x14)
	좌표Z := mem.read(0x0058DAD4, "UInt", 0x18)

	현재HP := mem.read(0x0058DAD4, "UInt", 0x178, 0x5B)
	최대HP := mem.read(0x0058DAD4, "UInt", 0x178, 0x1F)

	현재MP := mem.read(0x0058DAD4, "UInt", 0x178, 0x5F)
	최대MP := mem.read(0x0058DAD4, "UInt", 0x178, 0x23)

	현재FP := mem.read(0x0058DAD4, "UInt", 0x178, 0x63)
	최대FP := mem.read(0x0058DAD4, "UInt", 0x178, 0x27)

	GuiControl,, FP, % 현재FP . " / " . 최대FP
	GuiControl,, 맵,(%맵번호%) %맵이름%
	guicontrol,,무기수리필요상태, %무기수리필요%
	guicontrol,,식빵구매필요상태, %식빵구매필요%
	guicontrol,,라깃구매필요상태, %라깃구매필요%
	GuiControl,, 좌표,(%차원%)X:%좌표X% Y:%좌표Y% Z:%좌표Z%
	GuiControl,, MP, % 현재MP . " / " . 최대MP
	GuiControl,, HP, % 현재HP . " / " . 최대HP

	if (현재HP = "" || 최대HP = "" || 최대MP = "" || 최대FP = "" || 인벤토리 = "")
	{
		SB_SetText("비정상",4)
		STOPSIGN := true
		서버상태 := False
		return
	}

	if (리메듐사용여부 = 1 && 리메듐사용제한 > 현재HP && 현재HP != "")
	{
		현재무기 := mem.read(0x0058DAD4, "UInt", 0x121)
		if (현재무기 != 0 && 현재무기 != 49153)
		{
			RunMemory("무기탈거")
		}
		sleep, 1
		마법사용("리메듐", "자신")
	}

	if (브렐사용여부 = 1 && 브렐사용제한 > 현재MP && 현재MP != "")
	{
		현재무기 := mem.read(0x0058DAD4, "UInt", 0x121)
		if (현재무기 != 0 && 현재무기 != 49153)
		{
			RunMemory("무기탈거")
		}
		sleep, 1
		마법사용("브렐","자신")
	}

	if (힐링포션사용여부 = 1 && 힐링포션사용제한 > 현재HP && 맵번호 != 2 && 맵번호 != 1002 && 맵번호 != 2002 && 맵번호 != 3002 && 맵번호 != 4002)
	{
		keyclick(힐링포션사용단축키)
		sleep,1
	}

	if (HP마을귀환사용여부 = 1 && HP마을귀환사용제한 > 현재HP && 현재HP != "" && 맵번호 != 2 && 맵번호 != 1002 && 맵번호 != 2002 && 맵번호 != 3002 && 맵번호 != 4002)
	{
		guicontrol, ,마지막사냥장소, %맵번호%
		guicontrol, ,마을귀환이유, 현재HP %현재HP% 가 %HP마을귀환사용제한% 보다 낮음
		SB_setText(HP마을귀환사용제한 "/" 현재HP "HP부족",1)
		마을 := "포프레스네"
		목적차원 := "감마"
		설정된마을 := [4002,2002,3002]
		if (오란의깃사용여부 = 1)
		{
			keyclick(오란의깃단축키)
			sleep, 1000
			맵번호 := mem.read(0x0058EB1C, "UInt", 0x10E)
			if (IsDataInList(맵번호, 설정된마을))
				return
		}
		라깃사용하기(마을,목적차원)
		sleep,100

		return
	}

	if (마나포션사용여부 = 1) && (마나포션사용제한 > 현재MP) && ( 현재MP != "") && (맵번호 != 2 && 맵번호 != 1002 && 맵번호 != 2002 && 맵번호 != 3002 && 맵번호 != 4002 )
	{
		SB_SETtext("마나포션사용" ,1)
		keyclick(마나포션사용단축키)
		sleep,1
	}

	if (MP마을귀환사용여부 = 1 && MP마을귀환사용제한 > 현재MP && 맵번호 != 2 && 맵번호 != 1002 && 맵번호 != 2002 && 맵번호 != 3002 && 맵번호 != 4002)
	{
		guicontrol, ,마지막사냥장소, %맵번호%
		guicontrol, ,마을귀환이유, 현재MP %현재MP% 가 %MP마을귀환사용제한% 보다 낮음
		SB_setText(MP마을귀환사용제한 "/" 현재MP "HP부족",1)
		마을 := "포프레스네"
		목적차원 := "감마"
		설정된마을 := [4002,2002,3002]
		if (오란의깃사용여부 = 1)
		{
			keyclick(오란의깃단축키)
			sleep, 1000
			맵번호 := mem.read(0x0058EB1C, "UInt", 0x10E)
			if (IsDataInList(맵번호, 설정된마을))
				return
		}
		라깃사용하기(마을,목적차원)
		return
	}

	if (식빵사용여부 = 1 && 식빵사용제한 > 현재FP && 최대FP !="" )
	{
		SB_SETtext("식빵사용" ,3)
		if (현재FP기록 = 현재FP)
		{
			식빵사용카운트++
		}
		현재FP기록 := 현재FP
		keyclick(식빵사용단축키)
	}

	경과시간 := floor((A_TickCount - StartTime) / 1000)
	guicontrolget,시작마력
	guicontrolget,시작체력

	시작마력 += 0
	시작체력 += 0

	최대HP += 0
	최대MP += 0

	상승체력 := floor(최대HP - 시작체력)
	예상시간당상승체력 := floor((상승체력 / 경과시간) * 60 * 60)
	guicontrol, ,현재체력,%상승체력% (%예상시간당상승체력%/H)

	상승마력 := floor(최대MP - 시작마력)
	예상시간당상승마력 := floor((상승마력 / 경과시간) * 60 * 60)
	guicontrolget,인트
	인트 += 0
	수동레벨기입 += 0
	최대마력량 := 인트 * 10 + 수동레벨기입 * 5
	if (최대마력량 <= 최대MP && 최대MP != 0 && 최대MP != "" && CurrentMode = "나프마통작" && 최대마력량 != 0 && 최대마력량 != "" && Coin = True)
	{
		guicontrol, ,현재마력,%상승마력% (최대치%최대마력량%도달)
	}
	else
		guicontrol, ,현재마력,%상승마력% (%예상시간당상승마력%/h) / %최대마력량%

	if (최대FP < 1000)
	{
		guicontrolget,시작밥통
		시작밥통 += 0
		최대FP += 0
		상승밥통 := floor(최대FP - 시작밥통)
		예상시간당상승밥통 := floor((상승밥통 / 경과시간) * 60 * 60)
		guicontrol, ,현재밥통,%상승밥통% (%예상시간당상승밥통%/h)
	}
	else
	{
		guicontrol, ,현재밥통, 최대치도달
	}
	guicontrol, ,경과시간,작동시간 %경과시간% 초
	GetMoreInformation()
	return
;}

;}

;-------------------------------------------------------
;-------인터페이스영역-----------------------------------
;-------------------------------------------------------
;{
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
			if (temp_variable = "상인단순제작" || temp_variable = "상인어빌수련")
			{
				temp_variable := "대기모드"
			}
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
					else if (item = "MoveSpeed")
					temp_variable := 180
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
{ ;현재 선택된 옵션을 캐릭터명의 폴더에 저장합니다.
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
;{
GuiControlGet, CurrentTab, , Tab1
Gui, Color, FFFFFF
if (CurrentTab != 5 && CurrentTab != 2 && CurrentTab != 8)
{
	Gui, Show, w500 h452, %ThisWindowTitle%
	GuiControl, move, Tab1, w496 h426
}
else if (CurrentTab = 5 || CurrentTab = 8)
{
	Gui, Show, w1000 h452, %ThisWindowTitle%
	GuiControl, move, Tab1, w996 h426
}
else if (CurrentTab = 2)
{
	Gui, Show, w665 h452, %ThisWindowTitle%
	GuiControl, move, Tab1, w656 h426
}
return
;}

GuiClose:
;{
gosub, SaveBeforeExit
ExitApp
;}

ShowGui:
;{
;600x400
Gui, Add, Tab2, vTab1 x2 y2 w496 h426 AltSubmit cBlack gTab, 기본|설정|아템|이동|검색|파티|기타|그레이드 ;|개발용|스킬
Gui, Font, S9 Arial ,
Gui, Color, FFFFFF
gui, tab, 1
;캐릭터선택영역
Gui, Add, GroupBox, x15 y30 w160 h180, 캐릭터 선택
Gui, Add, ListBox, x25 y50 w140 h130 g일랜시아선택 vElanciaTitle , %ElanTitles%
Gui, Add, Button, x35 y180 w120 h20 g일랜시아새로고침, 새로고침
;캐릭터정보영역
Gui, Add, GroupBox, x180 y30 w150 h180,
Gui, Add, Button, x190 y50 w130 h20, 일랜시작
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
Gui, Add, Text, x345 y48 w25 h18 ,STR
Gui, Add, Text, +Right x370 y48 w30 h18 vSTR,
Gui, Add, Text, x415 y48 w20 h18 ,AGI
Gui, Add, Text, +Right x440 y48 w30 h18 vAGI,
Gui, Add, Text, x345 y66 w25 h18 ,INT
Gui, Add, Text, +Right x370 y66 w30 h18 v인트,
Gui, Add, Text, x415 y66 w20 h18 ,VIT
Gui, Add, Text, +Right x440 y66 w30 h18 vVIT,

Gui, Add, Text, x345 y84 w70 h18 ,QUANTITY
Gui, Add, Text, +Right x420 y84 w50 h18 vQUANTITY,
Gui, Add, Text, x345 y102 w60 h18 ,GALRID
Gui, Add, Text, +Right x410 y102 w60 h18 vGALRID,
Gui, Add, Text, x345 y120 w60 h18 ,VOTE
Gui, Add, Text, +Right x410 y120 w60 h18 vVOTE,
Gui, Add, Text, x345 y138 w60 h18 ,FRAME
Gui, Add, Text, +Right x410 y138 w60 h18 vFRAME,

Gui, Add, Text, x345 y156 w130 h18 v좌표,
Gui, Add, Text, x345 y174 w130 h30 v맵,

Gui, Add, CheckBox, x15 y220 v아템먹기여부, 먹자(+채광)
Gui, Add, CheckBox, x105 y220 v자동사냥여부, 자동사냥
Gui, Add, CheckBox, x195 y220 v자동이동여부, 자동이동
Gui, Add, DropDownList, x280 y215 w80 vCurrentMode,대기모드||자동감응|일반자사|포남자사|포북자사|광물캐기|배달하기|나프마통작|행깃구매|행깃교환
Gui, Add, Button, x375 y213 w100 g실행 v실행, 실행
Gui, Add, Button, x375 y213 w100 Hidden g중지 v중지, 중지

Gui, Add, GroupBox, x15 y240 w470 h185, 상태창
;HP 영역
Gui, Add, Text, x25 y260 w30 h20 ,HP
Gui, Add, Text, +Right x45 y260 w110 h20 vHP,

Gui, Add, text, +Right x45 y280 w110 h20 v현재체력 , 현재체력

Gui, Add, Text, x25 y300 w140 h20,힐링포션 사용
Gui, Add, checkbox, x25 y315 w20 h20 v힐링포션사용여부,
Gui, Add, Edit, x50 y315 w55 h20 v힐링포션사용제한,
Gui, Add, DropDownList, x110 y315 w50 h60 v힐링포션사용단축키,5||6|7|8

Gui, Add, Text, x25 y340 w140 h20,마을귀환
Gui, Add, checkbox, x25 y355 w20 h20 vHP마을귀환사용여부,
Gui, Add, Edit, x50 y355 w55 h20 vHP마을귀환사용제한,
Gui, Add, DropDownList, x110 y355 w50 h60 v오란의깃사용단축키,5||6|7|8

Gui, Add, Text, x25 y380 w140 h20,리메듐사용
Gui, Add, checkbox, x25 y395 w20 h20 v리메듐사용여부,
Gui, Add, Edit, x50 y395 w55 h20 v리메듐사용제한,


;MP 영역
Gui, Add, Text, x180 y260 w30 h20 ,MP
Gui, Add, Text, +Right x200 y260 w110 h20 vMP,
Gui, Add, edit, +Right x180 y277 w20 h20 v수동레벨기입,
Gui, Add, text, +Right x200 y280 w110 h20 v현재마력 , 현재마력

Gui, Add, Text, x180 y300 w110 h20,마나포션 사용
Gui, Add, checkbox, x180 y315 w20 h20 v마나포션사용여부,
Gui, Add, Edit, x205 y315 w55 h20 v마나포션사용제한,
Gui, Add, DropDownList, x265 y315 w50 h60 v마나포션사용단축키,5|6||7|8

Gui, Add, Text, x180 y340 w140 h20,마을귀환
Gui, Add, checkbox, x180 y355 w20 h20  vMP마을귀환사용여부,
Gui, Add, Edit, x205 y355 w55 h20 vMP마을귀환사용제한,

Gui, Add, Text, x180 y380 w140 h20,브렐사용
Gui, Add, checkbox, x180 y395 w20 h20 v브렐사용여부,
Gui, Add, Edit, x205 y395 w55 h20 v브렐사용제한,

;FP 영역
Gui, Add, Text, x335 y260 w30 h20 ,FP
Gui, Add, Text, +Right x355 y260 w110 h20 vFP,

Gui, Add, text,  +Right x355 y280 w110 h20 v현재밥통 , 현재밥통

Gui, Add, Text, x335 y300 w140 h20,식빵 사용
Gui, Add, checkbox, x335 y315 w20 h20 v식빵사용여부,
Gui, Add, Edit, x360 y315 w55 h20 v식빵사용제한,1
Gui, Add, DropDownList, x420 y315 w50 h60 v식빵사용단축키,9||

Gui, Add, Text, x335 y340 w140 h20,식빵구매
Gui, Add, checkbox, x335 y355 w20 h20  v식빵구매여부,
Gui, Add, DropDownList, x360 y355 w110 h80  v식빵구매마을,로랜시아||에필로리아|세르니카|크로노시스|포프레스네

Gui, Add, Text, x335 y380 w140 h20,골드바
Gui, Add, checkbox, x335 y395 w20 h20  v골드바판매여부,
Gui, Add, Text, x355 y400 w30 h20 ,판매
Gui, Add, checkbox, x400 y395 w20 h20  v골드바구매여부,
Gui, Add, Text, x420 y400 w30 h20 ,구매

gui, tab, 2
Gui, Add, GroupBox, x15 y30 w80 h85, 무기바꾸기
Gui, Add, Radio, x25 y50 h20 g사용자선택 v주먹 , 주먹
Gui, Add, Radio, x25 y70 h20 g사용자선택 v일무기 , 1무기
Gui, Add, Radio, x25 y90 h20 g사용자선택 v이벗무바 checked, 2벗무바

Gui, Add, GroupBox, x15 y120 w164 h80, 치트엔진

Gui, Add, Checkbox, x25 y135 h20 g사용자선택 v위치고정,위치고정
Gui, Add, Checkbox, x25 y155 h20 g사용자선택 v배경제거,배경제거
Gui, Add, Checkbox, x25 y175 h20 g사용자선택 v캐릭제거,캐릭제거
Gui, Add, Checkbox, x105 y135 h20 g사용자선택 v제작이동,제작이동

Gui, Add, GroupBox, x180 y30 w152 h240, 어빌사용
Gui, Add, GroupBox, x99 y30 w80 h85, 데미지
Gui, Add, Radio, x115 y50 h20  g사용자선택 v퍼펙트 checked, 퍼핵
Gui, Add, Radio, x115 y70 h20  g사용자선택 v일반, 일반
Gui, Add, Radio, x115 y90 h20  g사용자선택 v미스, 미스

Gui, Add, checkbox, x190 y50 h20  v대화사용, 대화
Gui, Add, checkbox, x190 y70 h20  v명상사용, 명상
Gui, Add, checkbox, x190 y90 h20  v더블어택사용, 덥택
Gui, Add, checkbox, x190 y110 h20  v체력향상사용, 체향
Gui, Add, checkbox, x190 y130 h20  v민첩향상사용, 민향
Gui, Add, checkbox, x190 y150 h20  v활방어사용, 활방어
Gui, Add, checkbox, x190 y170 h20 w70 v마력향상사용, 마력향상
Gui, Add, checkbox, x190 y190 h20 w70 v마법방어향상사용, 마방향상
Gui, Add, checkbox, x190 y210 h20  v훔치기사용, 훔치기
Gui, Add, checkbox, x190 y230 h20  v훔쳐보기사용, 훔쳐보기
Gui, Add, checkbox, x260 y50 h20  v현혹사용, 현혹
Gui, Add, checkbox, x260 y70 h20  v폭검사용, 폭검
Gui, Add, checkbox, x260 y90 h20  v독침사용, 독침
Gui, Add, checkbox, x260 y110 h20 w70  v무기공격사용, 무기공격
Gui, Add, checkbox, x260 y130 h20  v집중사용, 집중
Gui, Add, checkbox, x260 y150 h20  v회피사용, 회피
Gui, Add, checkbox, x260 y170 h20  v몸통지르기사용, 몸찌
Gui, Add, checkbox, x260 y190 h20  vRemoveArmor사용, 리뭅
Gui, Add, checkbox, x260 y210 h20  vSENSE사용, SENSE

Gui, Add, GroupBox, x15 y205 w164 h65,퀵슬롯사용
Gui, Add, checkbox, x30 y225 h20  v3번, 3번
Gui, Add, checkbox, x75 y225 h20  v4번, 4번
Gui, Add, checkbox, x120 y225 h20  v5번, 5번
Gui, Add, checkbox, x30 y245 h20  v6번, 6번
Gui, Add, checkbox, x75 y245 h20  v7번, 7번
Gui, Add, checkbox, x120 y245 h20  v8번, 8번

Gui, Add, GroupBox, x15 y275 w82 h145,엘
Gui, Add, checkbox, x25 y295 h15  v리메듐사용, 리메듐
Gui, Add, checkbox, x25 y315 h15 w70 v라리메듐사용, 라리메듐
Gui, Add, checkbox, x25 y335 h15 w70 v엘리메듐사용, 엘리메듐
Gui, Add, checkbox, x25 y355 h15  v쿠로사용, 쿠로
Gui, Add, checkbox, x25 y375 h15 w70 v빛의갑옷사용, 빛의갑옷
Gui, Add, checkbox, x25 y395 h15 w70 v공포보호사용, 공포보호

coord_x := 15 + 82 * 1
Gui, Add, GroupBox, x%coord_x% y275 w82 h120,다뉴
coord_x := 25 + 82 * 1
Gui, Add, checkbox, x%coord_x% h15  y295 v다라사용, 다라
Gui, Add, checkbox, x%coord_x% h15  y315 v브렐사용, 브렐
Gui, Add, checkbox, x%coord_x% h15  y335 v브레마사용, 브레마
Gui, Add, checkbox, x%coord_x% h15  y355 w70 v물의갑옷사용, 물의갑옷
Gui, Add, checkbox, x%coord_x% h15  y375 v감속사용, 감속
Gui, Add, checkbox, x%coord_x% h15  y395 v나프사용, 나프(엘)
coord_x := 15 + 82 * 2
Gui, Add, GroupBox, x%coord_x% y275 w77 h85,마하
coord_x := 25 + 82 * 2
Gui, Add, checkbox, x%coord_x% h15  y295 v마스사용, 마스
Gui, Add, checkbox, x%coord_x% h15  y315 v라크사용, 라크
Gui, Add, checkbox, x%coord_x% h15  y335 v번개사용, 번개

Gui, Add, checkbox, x%coord_x% y360 w80 h20 v원거리타겟,원거리타겟
Gui, Add, checkbox, x%coord_x% y380 w80 h20 v리메듐타겟,리메듐타겟
coord_x += 100
Gui, Add, Edit, x%coord_x%  y360 w100 h20 v원거리타겟아이디,이름
Gui, Add, Edit, x%coord_x%  y380 w100 h20 v리메듐타겟아이디,이름
coord_x += 100
Gui, Add, Edit, x%coord_x% hidden y360 w30 h20 v특수원거리타겟OID,0x0
Gui, Add, Edit, x%coord_x% hidden y380 w30 h20 v특수리메듐타겟OID,0x0

coord_x := 15 + 82 * 3 - 5
Gui, Add, GroupBox, x%coord_x% y275 w77 h85,브리깃드
coord_x := 25 + 82 * 3 - 5
Gui, Add, checkbox, x%coord_x% h20  y295 v브리스사용, 브리스
Gui, Add, checkbox, x%coord_x% h20  y315 v파스티사용, 파스티

coord_x := 15 + 82 * 4 - 5 * 2
Gui, Add, GroupBox, x%coord_x% y275 w82 h85,브라키
coord_x := 25 + 82 * 4 - 5 * 2
Gui, Add, checkbox, x%coord_x% h20  y295 v슈키사용, 슈키
Gui, Add, checkbox, x%coord_x% h20  y315 v클리드사용, 클리드
Gui, Add, checkbox, x%coord_x% h20 w70 y335 v스톤스킨사용, 스톤스킨

coord_x := 15 + 82 * 5 - 5 * 2
Gui, Add, GroupBox, x%coord_x% y275 w77 h85,테스
coord_x := 25 + 82 * 5  - 5 * 2
Gui, Add, checkbox, x%coord_x% h20  y295 v파라스사용, 파라스
Gui, Add, checkbox, x%coord_x% h20  y315 v베네피쿠스사용, 베네
Gui, Add, checkbox, x%coord_x% h20  y335 v저주사용, 저주

coord_x := 15 + 82 * 6 - 5 * 3
Gui, Add, GroupBox, x%coord_x% y275 w159 h145,수리 혹은 회복
coord_x := 25 + 82 * 6  - 5 * 3
Gui, Add, Radio, x%coord_x%  y295 w50 h20 checked v회복, 회복
Gui, Add, Radio, x%coord_x%  y315 w50 h20 , 안함
coord_x := 25 + 82 * 6  - 5 * 2 + 50
Gui, Add, Radio, x%coord_x%  y295 w70 h20 v수리, 수리
Gui, Add, Radio, x%coord_x%  y315 w70 h20 v소야수리, 소야수리

Gui, Add, GroupBox, x333 y30 w159 h60, 포레스트네NPC 대화
Gui, Add, checkbox, x348 y55 w15 h15 v포레스트네자동대화,
Gui, Add, dropdownlist, x373 y53 w60 v포레스트네자동대화딜레이, 10분|1분|5분|19분||29분
Gui, Add, Button, x438 y52 h20 w45 h20 g포레스트네자동대화실행, 실행

Gui, Add, GroupBox, x493 y30 w159 h60, 기타설정
coord_x := 493+15
Gui, Add, checkbox, x%coord_x% y45 w100 h20 v버스기사모드,버스기사모드
Gui, Add, checkbox, x%coord_x% y65 w100 h20 v자동그레이드,자동그레이드

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
LV_ModifyCol(6,0)
LV_ModifyCol(7,0)
LV_ModifyCol(8,0)
LV_ModifyCol(9,0)
LV_ModifyCol(10,0)
LV_ModifyCol(11,0)
LV_ModifyCol(12,0)

Gui, Add, GroupBox, x493 y95 h175 w159,고용상인리스트
Gui, Add, ListView, x496 y130 h135 w153 g고용상인리스트실행 v고용상인리스트 +altsubmit, 분류|차원|맵이름|번호|이름|OID|X|Y|Z|우선순위|주소|이미지
LV_ModifyCol(1,0)
LV_ModifyCol(2,40)
LV_ModifyCol(3,0)
LV_ModifyCol(4,0)
LV_ModifyCol(5,80)
LV_ModifyCol(6,0)
LV_ModifyCol(7,0)
LV_ModifyCol(8,0)
LV_ModifyCol(9,0)
LV_ModifyCol(10,0)
LV_ModifyCol(11,0)
LV_ModifyCol(12,0)
coord_x := 506
Gui, Add, Text, x%coord_x%  y342 w60 h15 ,소야이름
Gui, Add, Text, x%coord_x%  y362 w60 h15 ,템순서
Gui, Add, Text, x%coord_x%  y382 w60 h15 ,템갯수
Gui, Add, Text, x%coord_x%  y402 w60 h15 ,템단축키
coord_x := 566
Gui, Add, Edit, x%coord_x%  y337 w80 h20 v수리소야이름,수리소야이름
Gui, Add, Edit, x%coord_x%  y357 w80 h20 v수리소야아이템순서,아이템순서
Gui, Add, Edit, x%coord_x%  y377 w80 h20 v수리소야아이템갯수,아이템갯수
Gui, Add, DropDownList, x%coord_x%  y397 w80  v링단축키,3||4|5|6|7
gui, tab, 3 ;기본|설정|아템|좌표|검색|기타
Gui, Add, text, x15 y33 w180 h20 ,원하는템(광물/줍줍)
Gui, Add, edit, x15 y50 w180 h20 v원하는아이템추가할아이템명,
Gui, Add, button, x15 y70 w85 h20 g원하는아이템넣을아이템추가, 추가
Gui, Add, button, x110 y70 w85 h20 g원하는아이템넣을아이템삭제, 삭제
Gui, Add, ListView, x15 y100 h200 w180 v원하는아이템리스트 +altsubmit, 원하는아이템
LV_ModifyCol(1,150)
Gui, Add, ListView, x15 y300 h100 w180 v소지아이템리스트 +altsubmit, 인벤토리아이템|수량
LV_ModifyCol(1,120)
LV_ModifyCol(2,40)

Gui, Add, checkbox, x200 y30 w140 h20 v은행넣기활성화,은행넣기활성화
Gui, Add, edit, x200 y50 w140 h20 v은행넣기추가할아이템명,
Gui, Add, button, x200 y70 w65 h20 g은행넣을아이템추가, 추가
Gui, Add, button, x275 y70 w65 h20 g은행넣을아이템삭제, 삭제
Gui, Add, ListView, x200 y100 h200 w140 v은행넣을아이템리스트 +altsubmit,보관아이템
LV_ModifyCol(1,100)
Gui, Add, ListView, x200 y300 h100 w140 v은행넣을아이템대기리스트 +altsubmit,대기리스트
LV_ModifyCol(1,100)

Gui, Add, checkbox, x345 y30 w140 h20 v소각활성화,소각활성화
Gui, Add, edit, x345 y50 w140 h20 v소각하기추가할아이템명,
Gui, Add, button, x345 y70 w65 h20 g소각할아이템추가, 추가
Gui, Add, button, x420 y70 w65 h20 g소각할아이템삭제, 삭제
Gui, Add, ListView, x345 y100 h200 w140 v소각할아이템리스트 +altsubmit,소각아이템
LV_ModifyCol(1,100)
Gui, Add, ListView, x345 y300 h100 w140 v소각할아이템대기리스트 +altsubmit,대기리스트
LV_ModifyCol(1,100)
Gui, Add, Text, x15 y400 h25 w450,소각사용시 중요한 물품은 미리 은행에 넣어주세요. `n(낚시/광산캐기/제작등과 은행넣기/소각이 동시에 일어나면 오류발생가능성 높음)

gui, tab, 4
Y_coord := 35
Y_coord_ := Y_coord - 3
Gui, Add, CheckBox, x15 y%Y_coord% h20 w45 v오란의깃사용여부, 오깃
Gui, Add, DropDownList, x60 y%Y_coord_% w50 v오란의깃단축키, 3||4|5|6|7
Gui, Add, DropDownList, x110 y%Y_coord_% w100 v오란의깃마을, 로랜시아||에필로리아|세르니카|크로노시스|포프레스네

Y_coord += 22
Y_coord_ := Y_coord - 3
Gui, Add, CheckBox, x15 y%Y_coord%  h20 w145 v길탐색책사용, 길탐색책사용, 단축키
Gui, Add, DropDownList, x170 y%Y_coord_% w40 v길탐색책단축키, 3||4|5|6|7|8
Y_coord += 22
Y_coord_ := Y_coord - 3
Gui, Add, CheckBox, x15 y%Y_coord% h20 w40 v길탐색1번사용여부, 1번
Gui, Add, DropDownList, x60 y%Y_coord_% w150 v길탐색1번목적지, 로랜시아 목공소||로랜시아 퍼브|로랜시아 우체국|에필로리아 퍼브|에필로리아 우체국|에필로리아 목공소|세르니카 퍼브|세르니카 우체국|세르니카 목공소|포프레스네 무기상점
Y_coord += 22
Y_coord_ := Y_coord - 3
Gui, Add, CheckBox, x15 y%Y_coord% h20 w40 v길탐색2번사용여부, 2번
Gui, Add, DropDownList, x60 y%Y_coord_% w150 v길탐색2번목적지, 로랜시아 목공소||로랜시아 퍼브|로랜시아 우체국|에필로리아 퍼브|에필로리아 우체국|에필로리아 목공소|세르니카 퍼브|세르니카 우체국|세르니카 목공소|포프레스네 무기상점
Y_coord += 22
Y_coord_ := Y_coord - 3
Gui, Add, CheckBox, x15 y%Y_coord% h20 w40 v길탐색3번사용여부, 3번
Gui, Add, DropDownList, x60 y%Y_coord_% w150 v길탐색3번목적지, 로랜시아 목공소||로랜시아 퍼브|로랜시아 우체국|에필로리아 퍼브|에필로리아 우체국|에필로리아 목공소|세르니카 퍼브|세르니카 우체국|세르니카 목공소|포프레스네 무기상점
Y_coord += 22
Y_coord_ := Y_coord - 3
Gui, Add, CheckBox, x15 y%Y_coord% h20 w40 v길탐색4번사용여부, 4번
Gui, Add, DropDownList, x60 y%Y_coord_% w150 v길탐색4번목적지, 로랜시아 목공소||로랜시아 퍼브|로랜시아 우체국|에필로리아 퍼브|에필로리아 우체국|에필로리아 목공소|세르니카 퍼브|세르니카 우체국|세르니카 목공소|포프레스네 무기상점
Y_coord += 22
Y_coord_ := Y_coord - 3
Gui, Add, CheckBox, x15 y%Y_coord% h20 w40 v길탐색5번사용여부, 5번
Gui, Add, DropDownList, x60 y%Y_coord_% w150 v길탐색5번목적지, 로랜시아 목공소||로랜시아 퍼브|로랜시아 우체국|에필로리아 퍼브|에필로리아 우체국|에필로리아 목공소|세르니카 퍼브|세르니카 우체국|세르니카 목공소|포프레스네 무기상점


Y_coord += 22
Y_coord_ := Y_coord - 3
Gui, Add, checkbox, x15 y%Y_coord% w120 h20 v수련길탐딜레이, 수련길탐딜레이
Gui, Add, EDIT, x125 y%Y_coord_% w70 h20 v수련용길탐색딜레이,
Gui, Add, checkbox, x215 y%Y_coord% h20 v특오자동교환여부, 특오자동교환(길탐색3번 성검사 4번 사냥터)
Y_coord += 22
Y_coord_ := Y_coord - 3
Gui, Add, checkbox, x15 y%Y_coord% w100 h20 g사용자선택 v이동속도사용, 이동속도
Gui, Add, EDIT, x125 y%Y_coord_% w70 h20 vMoveSpeed,
Y_coord += 22
Y_coord_ := Y_coord - 3
Gui, Add, checkbox, x15 y%Y_coord% w100 h20 g사용자선택 v게임배속사용, 게임배속
Gui, Add, EDIT, x125 y%Y_coord_% w70 h20 v게임배속,

Y_coord := 35
Gui, Add, Text, x215 y%Y_coord% h20 w70, 목적지가기
Y_coord -= 3
Gui, Add, Radio, x285 y%Y_coord% h20 w50 g사용자선택 v차원결정유지 checked, 유지
Gui, Add, Radio, x335 y%Y_coord% h20 w50 g사용자선택 v차원결정알파, 알파
Gui, Add, Radio, x385 y%Y_coord% h20 w50 g사용자선택 v차원결정베타, 베타
Gui, Add, Radio, x435 y%Y_coord% h20 w50 g사용자선택 v차원결정감마, 감마

Y_coord += 22
Gui, Add, Button, x215 y%Y_coord% h20 w70 ,로랜시아
Gui, Add, Button, x290 y%Y_coord% h20 w60 ,퍼브
Gui, Add, Button, x355 y%Y_coord% h20 w60 ,우체국
Gui, Add, Button, x420 y%Y_coord% h20 w60, 목공소

Y_coord += 22
Gui, Add, Button, x215 y%Y_coord% h20 w70, 에필로리아
Gui, Add, Button, x290 y%Y_coord% h20 w60, 퍼브
Gui, Add, Button, x355 y%Y_coord% h20 w60, 우체국
Gui, Add, Button, x420 y%Y_coord% h20 w60, 목공소

Y_coord += 22
Gui, Add, Button, x215 y%Y_coord% h20 w70, 세르니카
Gui, Add, Button, x290 y%Y_coord% h20 w60, 퍼브
Gui, Add, Button, x355 y%Y_coord% h20 w60, 우체국
Gui, Add, Button, x420 y%Y_coord% h20 w60, 목공소

Y_coord += 22
Gui, Add, Button, x215 y%Y_coord% h20 w70, 크로노시스
Gui, Add, Button, x290 y%Y_coord% h20 w60, 베이커리
Gui, Add, Button, x355 y%Y_coord% h20 w60, 마법상점
Gui, Add, Button, x420 y%Y_coord% h20 w60, 무기상점

Y_coord += 22
Gui, Add, Button, x215 y%Y_coord% h20 w70, 포프레스네
Gui, Add, Button, x290 y%Y_coord% h20 w60, 베이커리
Gui, Add, Button, x355 y%Y_coord% h20 w60, 마법상점
Gui, Add, Button, x420 y%Y_coord% h20 w60, 무기상점

Y_coord += 22
Gui, Add, Button, x215 y%Y_coord% h20 w70,
Gui, Add, Button, x290 y%Y_coord% h20 w60, 감옥섬
Gui, Add, Button, x355 y%Y_coord% h20 w60, 라그네토
Gui, Add, Button, x420 y%Y_coord% h20 w60, 보물섬


Gui, Add, Text, x15 y265 h15 w80, 좌표리스트
Gui, Add, button, x370 y260 w80 h20 g좌표리스트추가 , 좌표추가
Gui, Add, ListView, x15 y285 h135 w465 v좌표리스트 g좌표리스트실행 +altsubmit, 번호|순번|맵이름|X|Y|Z
LV_ModifyCol(1,50)
LV_ModifyCol(2,50)
LV_ModifyCol(3,200)
LV_ModifyCol(4,40)
LV_ModifyCol(5,40)
LV_ModifyCol(6,40)

gui, tab, 5
Gui, Add, text, x15 y33 w180 h20 ,사냥을원하는몬스터
Gui, Add, edit, x15 y50 w180 h20 v원하는몬스터추가할몬스터명,
Gui, Add, button, x15 y70 w85 h20 g원하는몬스터추가, 추가
Gui, Add, button, x110 y70 w85 h20 g원하는몬스터삭제, 삭제
Gui, Add, ListView, x15 y95 h90 w240 v원하는몬스터리스트 +altsubmit, 사냥할몬스터
LV_ModifyCol(1,200)

Gui, Add, text, x15 y193 w180 h20 ,사냥을원하지않는몬스터
Gui, Add, edit, x15 y210 w180 h20 v원하지않는몬스터추가할몬스터명,
Gui, Add, button, x15 y230 w85 h20 g원하지않는몬스터추가, 추가
Gui, Add, button, x110 y230 w85 h20 g원하지않는몬스터삭제, 삭제
Gui, Add, ListView, x15 y255 h90 w240 v원하지않는몬스터리스트 +altsubmit, 사냥안할몬스터
LV_ModifyCol(1,200)

/*
Gui, Add, Text, x15 y280 h15 w80, 블랙 리스트
Gui, Add, ListView, x15 y295 h120 w240 v블랙리스트 g블랙리스트실행 +altsubmit, 분류|차원|맵이름|번호|이름|OID|X|Y|Z|삭제카운트
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
*/

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
gui, add, button, x400 y35 g마하디움링교환, 마하디움링교환
x_coord := 15
Y_coord := 50
loop, 10
{
	Gui, Add, Checkbox, x%x_coord% y%y_coord% w20 h20 v%A_Index%번캐릭터사용여부,
	Y_coord += 20
}
x_coord := 35
Y_coord := 50
loop, 10
{
	Gui, Add, Edit, x%x_coord% y%y_coord% w100 h20 v%A_Index%번캐릭터명,
	Y_coord += 20
}
Gui, Add, Button, x%x_coord% y%y_coord% w100 h20 g파티캐릭터재확인, 새로고침
Y_coord += 20
Gui, Add, Button, x%x_coord% y%y_coord% w100 h20 g원격파티하기, 파티하기
Y_coord += 20
Gui, Add, Checkbox, x15 y%y_coord% w120 h20 v자동파티여부, 1분마다다시파티
gui, tab, 7  ;기본|설정|아템|좌표|검색|기타|번외
x_coord := 15
y_coord := 30
Gui, Add, GroupBox, x%x_coord% y%y_coord% w466 h110, 부의 축적 - 제작 (단축키 9번 키아무기, 0번 수련장비)
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
Gui, Add, button, x%x_coord% y%y_coord% w125 h20 gCurrentMode_상인어빌수련, 제작 - 재료소모X
x_coord := 15 + 10 + 125+10
Gui, Add, button, x%x_coord% y%y_coord% w125 h20 gCurrentMode_상인단순제작, 제작 - 단순클릭
x_coord := 15 + 10 + 90 * 4
Gui, Add, button, x%x_coord% y%y_coord% w80 h20 g중지, 중지

x_coord := 15
y_coord := 145
Gui, Add, GroupBox, x%x_coord% y%y_coord% w466 h150,
; GroupBox 내부의 컴포넌트들
Gui, Add, Text, x30 y170 w150 h20 v시작시간, 시작시간
Gui, Add, Text, x30 y190 w150 h20 v경과시간,
Gui, Add, Text, x30 y210 w150 h20 v재접속횟수기록,
Gui, Add, Text, x30 y230 w150 h20 v접속여부확인상태,

Gui, Add, Text, x200 y170 w150 h20, NPC 자동 대화 대기
Gui, Add, Text, x200 y190 w150 h20, 해상도 배율
Gui, Add, Text, x200 y210 w150 h20, NPC 대화 주소
Gui, Add, Text, x200 y230 w150 h20, 좌측 상단 알림 주소
Gui, Add, Text, x200 y250 w150 h20, 상인 어빌 상승 어빌
Gui, Add, Text, x200 y270 w150 h20, 최근 상승 어빌 주소

Gui, Add, Text, x350 y170 w100 h20 vNPC대화딜레이
Gui, Add, Text, x350 y190 w100 h20 vMultiplyer
Gui, Add, Text, x350 y210 w100 h20 vNPC_MSG_ADR
Gui, Add, Text, x350 y230 w100 h20 vResult_Msg_Addr
Gui, Add, Text, x350 y250 w100 h20 v상승어빌
Gui, Add, Text, x350 y270 w100 h20 v상승어빌주소

x_coord := 15
y_coord := 300
Gui, Add, GroupBox, x%x_coord% y%y_coord% w466 h120, 프로그램정보
x_coord += 20
y_coord += 25
Gui, Add, Text,  x%x_coord% y%y_coord% w426 gOpenLink, H-Elancia는 "불법유료" 외부 프로그램의 경쟁력 약화를 위한 `n`n오픈소스, 무료 공개 프로젝트입니다.`n`n컴파일하여 사용함으로 발생하는 모든 책임은 최종 사용자에게 있습니다. `n `nhttps://github.com/SuperPowerJ/H-Elancia

 ;기본|설정|아템|좌표|검색|기타
gui, tab, 8

gui, add, text, x35 y35, 게임내에서 스킬순서를 바꿀 경우 체크를 꼭 다시 해야합니다.

gui, add, button, x500 y35 g그레이드하기, 그레이드하기
y_coord := 55
x_coord := 35
loop, 72
{
	x_coord_ := x_coord + 100
	x_coord__ := x_coord_ + 20
	temp_name := "어빌리티" . A_index . "_이름"
	gui, add, CheckBox, x%x_coord% y%y_coord% w100 h15 v%temp_name%,
	temp_name := "어빌리티" . A_index . "_그레이드"
	gui, add, text, x%x_coord_% y%y_coord% w20 h15  v%temp_name%,
	temp_name := "어빌리티" . A_index
	gui, add, text, x%x_coord__% y%y_coord% w50 h15  v%temp_name%,
	y_coord += 20
	if (A_index = 18 || A_index = 36 || A_index = 54)
	{
		y_coord := 55
		x_coord += 200
	}
}
y_coord := 55
x_coord += 200
loop, 18
{
	x_coord_ := x_coord + 100
	temp_name := "마법" . A_index . "_이름"
	gui, add, CheckBox, x%x_coord% y%y_coord% w100 h15 v%temp_name%,
	temp_name := "마법" . A_index
	gui, add, text, x%x_coord_% y%y_coord% w50 h15  v%temp_name%,
	y_coord += 20
	if (A_index = 18 || A_index = 36 || A_index = 54)
	{
		y_coord := 55
		x_coord += 200
	}
}

gui, tab, 10
Gui, Add, text, x280 y190 w100 h20, 마지막사냥장소
Gui, Add, EDIT, x395 y190 w70 h20 v마지막사냥장소 ,
Gui, Add, text, x125 y130 w140 h20 v스킬사용상태 , 스킬사용상태
Gui, Add, text, x125 y190 w140 h20 v현재TargetTitle , 현재TargetTitle

Gui, Add, text, x125 y230 w150 h20 v시작체력 , 시작체력
Gui, Add, text, x125 y250 w150 h20 v시작밥통 , 시작밥통
Gui, Add, text, x125 y270 w150 h20 v시작마력 , 시작마력


Gui, Add, text, x125 y310 w150 h20 v마을귀환이유, 마을귀환이유
Gui, Add, text, x125 y330 w100 h20 vabilityName0, 0
Gui, Add, text, x125 y350 w100 h20 vabilityName1, 0
Gui, Add, text, x125 y370 w100 h20 vabilityName2, 0
Gui, Add, text, x125 y390 w100 h20 vabilityName3, 0
Gui, Add, text, x225 y330 w100 h20 vabilityCount0, 0
Gui, Add, text, x225 y350 w100 h20 vabilityCount1, 0
Gui, Add, text, x225 y370 w100 h20 vabilityCount2, 0
Gui, Add, text, x225 y390 w100 h20 vabilityCount3, 0


Gui, Add, text, x25 y70 w100 h20 , 재접속
Gui, Add, text, x25 y90 w100 h20  , 접속여부확인

Gui, Add, text, x25 y130 w100 h20  , 스킬사용상태
Gui, Add, text, x25 y190 w100 h20  , TargetTitle

Gui, Add, text, x25 y230 w100 h20  , 시작체력
Gui, Add, text, x25 y250 w100 h20  , 시작밥통
Gui, Add, text, x25 y270 w100 h20  , 시작마력


Gui, Add, text, x25 y310 w100 h20 , 마을귀환이유
Gui, Add, text, x25 y330 w100 h20 , 영번어빌이름
Gui, Add, text, x25 y350 w100 h20 , 일번어빌이름
Gui, Add, text, x25 y370 w100 h20 , 이번어빌이름
Gui, Add, text, x25 y390 w100 h20 , 삼번어빌이름



Gui, Add, text, x280 y290 w100 h20, 식빵구매필요
Gui, Add, text, x280 y310 w100 h20, 라깃구매필요
Gui, Add, text, x280 y330 w100 h20, 무기수리필요
Gui, Add, text, x280 y350 w100 h20, CurrentMode



Gui, Add, text, x395 y290 w70 h20 v식빵구매필요상태,
Gui, Add, text, x395 y310 w70 h20 v라깃구매필요상태,
Gui, Add, text, x395 y330 w70 h20 v무기수리필요상태,
Gui, Add, text, x395 y350 w70 h20 vURL,

gui, tab, 9 ;스킬관련
forgui8items := ["SpellList","SkillListA"]
x_coord := 20
y_coord := 30
i := 1
For index, forgui8item in forgui8items
{
	For Index, spell in %forgui8item%
	{
		Gui, Add, Text, x%x_coord% y%y_coord% w50 h20 ,%spell%
		x_coordoff := x_coord + 50
		Gui, Add, Text, x%x_coordoff% y%y_coord% w25 h20 v%spell%번호,0
		x_coordoff := x_coord + 75
		Gui, Add, Text, x%x_coordoff% y%y_coord% w25 h20 v%spell%사용횟수,0
		Y_coord += 20
		if (i == 12 || i == 24 || i == 36)
		{
			x_coord := 120 * i / 12
			Y_coord := 30
		}
		i++
	}
}

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
SB_SetParts(100, 200, 130, 80, 400)
Gui, Show, w500 h452, %ThisWindowTitle%  ; GUI를 보이게 함

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
;}
Fill:
;{
if (TargetTitle != "")
{
	types := ["보관할아이템리스트", "원하는아이템리스트", "은행넣을아이템리스트", "소각할아이템리스트","원하는몬스터리스트","원하지않는몬스터리스트","NPC리스트", "좌표리스트","고용상인리스트"]
	for index, type in types
	{
		ListName := type
		Gui, ListView, %ListName%
		LV_Delete()
		Setting_Reload(ListName)
	}
	sleep, 1
	Gui,Listview,원하는아이템리스트
	sleep, 1
	RowCount := LV_GetCount()
	sleep, 1
	WantedItems := []
	sleep, 1
	Loop, %RowCount%
	{
		LV_GetText(row,A_Index,1)
		WantedItems.Push(row)  ; Add the current row's array to the main ListViewItems array
	}

	Gui,Listview,원하는몬스터리스트
	sleep, 1
	RowCount := LV_GetCount()
	sleep, 1
	WantedMonsters := []
	Loop, %RowCount%
	{
		LV_GetText(row,A_Index,1)
		WantedMonsters.Push(row)  ; Add the current row's array to the main ListViewItems array
	}
	WantedItemlength := WantedItems.MaxIndex()
	WantedMonsterlength := WantedMonsters.MaxIndex()

	Gui,Listview,원하지않는몬스터리스트
	sleep, 1
	RowCount := LV_GetCount()
	sleep, 1
	DisWantedMonsters := []
	Loop, %RowCount%
	{
		LV_GetText(row,A_Index,1)
		DisWantedMonsters.Push(row)  ; Add the current row's array to the main ListViewItems array
	}
	DisWantedMonsterlength := DisWantedMonsters.MaxIndex()

	저장위치 := a_scriptdir . "\SaveOf" . TargetTitle
	if !FileExist(저장위치)
	{
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
			else if (item = "MoveSpeed")
			temp_variable := 400
			else if (item = "게임배속")
			temp_variable := 5
			else
			temp_variable := 0
			GuiControl,,%Item%, %temp_variable%
		}
	}
}
Return
;}

;}

;-------------------------------------------------------
;-------백엔드영역---------------------------------------
;-------------------------------------------------------
;{

;총 4개의 스레드로 진행
;1. 모든 작업을 진행하는 메인루프
;2. Settimer1 서버연결상태를 확인하는 서버확인
;3. Settimer2 메인루프에서 관리하는 스킬사용
;4. Settimer3 주변몬스터 및 플레이어 그리고 아이템을 찾는 메모리검색

메인루프: ; 1. 메인 스레드
;{
	;만약 TargetTitle이 없다면 1000ms (= 1초)간 대기
	Loop,
	{
		FormatTime, CurrentTime,, HH:mm  ; 현재 시간을 HH:mm 형식으로 가져옵니다.
		SB_SetText("대기중" ,1)
		if (TargetTitle = "" || TargetTitle = "일랜시아 - 엘" || TargetTitle = "일랜시아 - 테스")
			sleep, 1000
		else
			break
	}

	서버상태 := True
	SetTimer, 접속여부확인, 10000
	SetTimer, 스킬사용하기, 1000
	SetTimer, 메모리검색_기본, 300
	FormatTime, CurrentTime,, HH:mm
	SB_SetText("불러오기완료", 1)
	;메인루프 실행
	Loop,
	{
		;{ 게임이 정상 작동중 이라면
		if (서버상태)
		{
			loop,
			{
				sleep, 1000
				FormatTime, CurrentTime,, HH:mm  ; 현재 시간을 HH:mm 형식으로 가져옵니다.
				SB_SetText("정상(" CurrentTime ")" ,4)
				if !(Coin)
				{
					continue
				}
				else if (서버상태) ;만약 서버접속중이 확인되면 현재 모드를 확인
				{
					guicontrolget,CurrentMode
					;만약 "대기모드" 라면
					if !(서버상태)
						break
					else if (CurrentMode = "대기모드")
					{
						loop,
						{
							if (CurrentMode = "대기모드") && (서버상태) && (Coin)
							{
								SB_SetText("대기모드",1)
								sleep,1000
							}
							else
							{
								sleep,1000
								break
							}
						}
					}
					else if (CurrentMode = "나프마통작")
					{
						Start_Inven := mem.read(0x0058DAD4, "UInt", 0x178, 0xBE, 0x14)
						gui, submit, nohide
						if (수리 = 1)  && (서버상태)
						{
							SetTimer,스킬사용하기,off
							sleep, 1500
							AttackStartCounter := A_TickCount
							gosub, 수리하기
							SetTimer,스킬사용하기,1000
						}
						else if (소야수리 = 1)
						{
							수리가필요한것같아 := 4
						}
						else if (회복 = 1)
						{
							SetTimer,스킬사용하기,off
							sleep, 1500
							AttackStartCounter := A_TickCount
							gosub, 회복하기
							SetTimer,스킬사용하기,1000
						}
						loop,
						{
							if (CurrentMode = "나프마통작") && (서버상태) && (Coin)
							{
								gui, submit, nohide
								SB_SetText("나프마통작",1)
								sleep,50
								gosub, 나프마통작
								MZ_Delay := A_TickCount - AttackStartCounter
								if (수리가필요한것같아 > 3 && 수리 = 1)  && (서버상태)
								{
									SetTimer,스킬사용하기,off
									sleep, 1500
									AttackStartCounter := A_TickCount
									gosub, 수리하기
									SetTimer,스킬사용하기,1000
								}
								else if (수리가필요한것같아 > 3 && 소야수리 = 1)  && (서버상태)
								{
									gosub, 아이템읽어오기
									InitialInven := 아이템갯수
									수리가필요한것같아 := 0
									CheatEngine_Buy_Unlimitted()
									SetTimer,스킬사용하기,off
									sleep, 1500
									guicontrolget,수리소야이름
									guicontrolget,수리소야아이템순서
									guicontrolget,링단축키
									guicontrolget,수리소야아이템갯수
									동작방법 := "Sell"
									loop, 5
									{
										if !(서버상태)
											break
										CheatEngine_Move_Sell()
										CheatEngine_Move_Buy()
										NpcMenuSelection := mem.read(0x0058F0A4, "UInt", aOffset*) ; 메뉴창이 잘 떳는지 확인
										if (NpcMenuSelection = 0)
										{
											SB_SetText("NPC호출실패 다시호출",2)
											CallSoya(수리소야이름)
										}
										else
										{
											SB_SetText("NPC호출성공",2)
											break
										}
										sleep, 100
									}
									loop, 5
									{
										NPCMENUSELECT(동작방법)
										sleep, 100
										if (Check_Shop(동작방법)!=0)
											break
									}

									NPC거래창첫번째메뉴클릭()
									loop, %수리소야아이템갯수%
									{
										keyclick("RightArrow")
										keyclick("DownArrow")
									}
									sleep,200
									NPC거래창OK클릭()
									sleep,1000
									NPC거래창닫기()
									sleep,1000
									gosub, 아이템읽어오기
									ChangedInven := 아이템갯수
									changes := ""
									for key, newValue in ChangedInven {
										if key == "GALRID"
											continue
										if InitialInven.HasKey(key) {
											changeAmount := newValue - InitialInven[key]
											if (changeAmount != 0) {
												changes .= key . "가 " . Abs(changeAmount) . "개 " . (changeAmount > 0 ? "증가되었습니다." : "감소되었습니다.") . "`n"
												추적아이템 := key
												변동된추적아이템갯수 := abs(changeAmount)
											}
										} else {
											changes .= key . "가 새로 추가되었습니다." . "`n"
											추적아이템 := key
											변동된추적아이템갯수 := ChangedInven[key]
										}
									}
									for key, oldValue in InitialInven {
										if key == "GALRID"
											continue
										if !ChangedInven.HasKey(key) {
											changes .= key . "가 제거되었습니다." . "`n"
											추적아이템 := key
											변동된추적아이템갯수 := InitialInven[key]
										}
									}
									InitialInven := 아이템갯수
									SB_SetText(추적아이템 " " 변동된추적아이템갯수 "개 판매됨" ,5)
									loop,
									{
										if !(서버상태)
											break
										동작방법 := "Buy"
										loop, 5
										{
											if !(서버상태)
												break
											CheatEngine_Move_Sell()
											CheatEngine_Move_Buy()
											NpcMenuSelection := mem.read(0x0058F0A4, "UInt", aOffset*) ; 메뉴창이 잘 떳는지 확인
											if (NpcMenuSelection = 0)
											{
												SB_SetText("NPC호출실패 다시호출",2)
												CallSoya(수리소야이름)
											}
											else
											{
												SB_SetText("NPC호출성공",2)
												break
											}
											sleep, 100
										}
										loop, 5
										{
											if !(서버상태)
												break
											NPCMENUSELECT(동작방법)
											sleep, 100
											if (Check_Shop(동작방법)!=0)
												break
										}
										NPC거래창첫번째메뉴클릭()
										아이템위치 := 수리소야아이템순서 - 1
										loop, % 아이템위치
										{
											if !(서버상태)
												break
											keyclick("DownArrow")
										}
										loop, %수리소야아이템갯수%
										{
											if !(서버상태)
												break
											keyclick("RightArrow")
										}
										sleep,200
										NPC거래창OK클릭()
										sleep,1000
										NPC거래창닫기()
										gosub, 아이템읽어오기
										ChangedInven := 아이템갯수
										changes := ""
										for key, newValue in ChangedInven {
											if key == "GALRID"
												continue
											if InitialInven.HasKey(key) {
												changeAmount := newValue - InitialInven[key]
												if (changeAmount != 0) {
													changes .= key . "가 " . Abs(changeAmount) . "개 " . (changeAmount > 0 ? "증가되었습니다." : "감소되었습니다.") . "`n"
													새추적아이템 := key
													변동된추적아이템갯수 := Abs(changeAmount)
												}
											} else {
												changes .= key . "가 새로 추가되었습니다." . "`n"
												새추적아이템 := key
												변동된추적아이템갯수 := ChangedInven[key]
												}
										}
										for key, oldValue in InitialInven {
											if key == "GALRID"
												continue
											if !ChangedInven.HasKey(key) {
												changes .= key . "가 제거되었습니다." . "`n"
												새추적아이템 := key
												변동된추적아이템갯수 := InitialInven[key]
											}
										}
										AttackStartCounter := A_TickCount
										if (추적아이템 != 새추적아이템)
										{
											SB_SetText(새추적아이템 "판매된 아이템과 구매된 아이템 불일치" ,5)
										}
										else if (아이템갯수[추적아이템] >= 변동된추적아이템갯수)
										{
											SB_SetText( 추적아이템 " " 아이템갯수[추적아이템] "개 소지중" ,5)
											break
										}
									}
									KeyClick(링단축키)
									sleep, 500
									SetTimer,스킬사용하기,1000
									Start_Inven := 아이템갯수[추적아이템]
								}
								else if (MZ_Delay > 600000 || 현재FP <1 ) && (회복 = 1) && (서버상태)
								{
									SetTimer,스킬사용하기,off
									sleep, 1500
									AttackStartCounter := A_TickCount
									gosub, 회복하기
									SetTimer,스킬사용하기,1000
								}
								if (수리 = 1 || 소야수리 = 1)  && (서버상태) && (MZ_Delay > 1000)
								{
									AttackStartCounter := A_TickCount
									gosub, 아이템읽어오기
									New_Inven := 아이템갯수[추적아이템]
									if (New_Inven > Start_Inven)
									{
										KeyClick(링단축키)
										수리가필요한것같아 += 1
									}
									else if (New_Inven < Start_Inven)
									{
										Start_Inven := New_Inven
									}
									else
									{
										수리가필요한것같아 := 0
									}
								}
							}
							else
							{
								sleep,1000
								break
							}
						}
					}
					else if (CurrentMode = "마잠또는밥통")
					{
						AttackStartCounter := A_TickCount
						SetTimer, 스킬사용하기, off
						loop,
						{
							if (CurrentMode = "마잠또는밥통") && (서버상태) && (Coin)
							{
								gui, submit, nohide
								SB_SetText("마잠또는밥통",1)
								sleep,1000
								MZ_Delay := A_TickCount - AttackStartCounter
								if (MZ_Delay > 600000 && 수리 = 1)
								{
									AttackStartCounter := A_TickCount
									gosub, 수리하기
								}
								else if (MZ_Delay > 600000 || 현재FP <1 ) && (회복 = 1)
								{
									AttackStartCounter := A_TickCount
									gosub, 회복하기
								}
								gosub, 스킬사용하기
							}
							else
							{
								sleep,1000
								SetTimer, 스킬사용하기, 1000
								break
							}
						}
					}
					else if (CurrentMode = "자동감응")
					{
						guicontrol,,포레스트네자동대화,1
						loop,
						{
							gui,submit,nohide
							sleep, 1000
							if (CurrentMode = "자동감응") && (서버상태) && (Coin)
							{
								맵번호 := mem.read(0x0058EB1C, "UInt", 0x10E)
								NPC_TALK_DELAY := A_TickCount - NPC_TALK_DELAYCOUNT
								if ( NPC_TALK_DELAY > 60000 && ( CurrentMode = "포남자사" || CurrentMode = "포북자사" ) && 포레스트네자동대화 = 1 )
								{
									NPC_TALK_DELAYCOUNT := A_TickCount
									NPC대화딜레이+=1
									guicontrol, ,NPC대화딜레이,%NPC대화딜레이%
									if (포레스트네자동대화딜레이 = "10분" )
										NPC대화반복시간 := 10
									else if (포레스트네자동대화딜레이 = "1분" )
										NPC대화반복시간 := 1
									else if (포레스트네자동대화딜레이 = "5분" )
										NPC대화반복시간 := 5
									else if (포레스트네자동대화딜레이 = "19분" )
										NPC대화반복시간 := 19
									else if (포레스트네자동대화딜레이 = "29분" )
										NPC대화반복시간 := 29
									if (NPC대화딜레이>=NPC대화반복시간)
									{
										gosub, 포레스트네자동감응
									}
								}
							}
							else
							{
								sleep,1000
								break
							}
						}
					}
					else if (CurrentMode = "리스무기구매") ;만약 "행깃구매" 모드라면
					{
						loop,
						{
							if (CurrentMode = "리스무기구매") && (서버상태) && (Coin)
							{
								gosub, 리스무기구매
							}
							else
							{
								sleep,1000
								break
							}
						}
					}
					else if (CurrentMode = "행깃구매") ;만약 "행깃구매" 모드라면
					{
						loop,
						{
							if (CurrentMode = "행깃구매") && (서버상태) && (Coin)
							{
								gosub, 행깃구매
							}
							else
							{
								sleep,1000
								break
							}
						}
					}
					else if (CurrentMode = "행깃교환") ;만약 "행깃구매" 모드라면
					{
						loop,
						{
							if (CurrentMode = "행깃교환") && (서버상태) && (Coin)
							{
								gosub, 행깃교환
							}
							else
							{
								sleep,1000
								break
							}
						}
					}
					else if (CurrentMode = "상인어빌수련") ;만약 "상인수련" 모드라면
					{
						loop,
						{
							if (CurrentMode = "상인어빌수련") && (서버상태) && (Coin)
							{
								gosub, 상인어빌수련
							}
							else
							{
								sleep,1000
								break
							}
						}
					}
					else if (CurrentMode = "상인단순제작") ;만약 "단순제작" 모드라면
					{
						loop,
						{
							if (CurrentMode = "상인단순제작") && (서버상태) && (Coin)
							{
								gosub, 상인단순제작
							}
							else
							{
								sleep,1000
								break
							}
						}
					}
					else if (CurrentMode = "광물캐기") ;만약 "광물캐기" 모드라면
					{
						guicontrol,,일무기,1
						loop,
						{
							if (CurrentMode = "광물캐기") && (서버상태) && (Coin)
							{
								gui,submit,nohide
								sleep, 1000
								좌표X := mem.read(0x0058DAD4, "UInt", 0x10)
								좌표Y := mem.read(0x0058DAD4, "UInt", 0x14)
								좌표Z := mem.read(0x0058DAD4, "UInt", 0x18)
								gui,listview,몬스터리스트
								자사_현재선택 := LV_GetNext(0)
								자사갯수 := LV_GetCount()
								sleep,1
								gui,listview,아이템리스트
								아템_현재선택 := LV_GetNext(0)
								sleep,1
								gui,listview,좌표리스트
								좌표_현재선택 := LV_GetNext(0)
								좌표갯수 := LV_GetCount()
								if ( 자사_현재선택 != 0 )
								{
									현재무기 := mem.read(0x0058DAD4, "UInt", 0x121)
									if (현재무기 != 45057) ;활
										keyclick(1)
									gui,listview,몬스터리스트
									lv_gettext(현재타겟이름,자사_현재선택,5)
									lv_gettext(현재타겟OID,자사_현재선택,6)
									lv_gettext(근접체크,자사_현재선택,12)
									다음타겟 := 자사_현재선택 + 1
									if 다음타겟 > 자사갯수
										다음타겟 := 1
									if ( 마지막타겟OID != 현재타겟OID ) ; 그 선택된 몬스터가 새로운 몬스터라면
									{
										SB_SetText("방해시도포착: " 현재타겟이름,2)
										마지막타겟OID := 현재타겟OID
										마지막타격번호 := mem.read(0x0058dad4,"UINT",0x1a5)
										mem.write(0x00590730, 현재타겟OID, "UInt", aOffsets*)
										mem.write(0x00584C2C, 현재타겟OID, "UInt", aOffsets*)
										시작X := 좌표X
										시작Y := 좌표Y
										시작Z := 좌표Z
										시작타격번호 := mem.read(0x0058dad4,"UINT",0x1a5)
										RunMemory("공격하기")
										continue
									}
									else ; 그 선택된 몬스터가 새로운 몬스터가 아니라면 ;블랙리스트에 등록할지 말지 결정
									{
										if (근접체크 = 1) ;도착했다면
										{
											SB_SetText( 현재타겟이름 " 근처에 도착완료",2)
											MLS_delay := 0
											continue
										}
										else if (좌표X != 시작X && 좌표Y != 시작Y)
										{
											SB_SetText(현재타겟이름 "근처에 가는중",2)
											MLS_delay := 0
											시작X := 좌표X
											시작Y := 좌표Y
											시작Z := 좌표Z
											continue
										}
										else if (좌표X = 시작X && 좌표Y = 시작Y) ; && 현재무기 != 45057) ;만약 2초간 몬스터와 거리 1 초과에 멈춰서있다면
										{
											mem.write(0x00590730, 다음타겟, "UInt", aOffsets*)
											mem.write(0x00584C2C, 다음타겟, "UInt", aOffsets*)
											SB_SetText(현재타겟이름 "에 도달불가 다음타겟 공격시도",2)
											시작X := 좌표X
											시작Y := 좌표Y
											시작Z := 좌표Z
											MLS_delay++
											RunMemory("공격하기")
											continue
										}
										else
										{
											시작X := 좌표X
											시작Y := 좌표Y
											시작Z := 좌표Z
										}
									}
									continue
								}
								else if (아템_현재선택 != 0 )
								{
									현재무기 := mem.read(0x0058DAD4, "UInt", 0x121)
									if (현재무기 != 53249) ;곡괭이
										keyclick(2)
									gui,listview,아이템리스트
									lv_gettext(현재타겟이름,아템_현재선택,5)
									lv_gettext(현재타겟OID,아템_현재선택,6)
									lv_gettext(근접체크,아템_현재선택,12)
									LV_GetText(목표X,아템_현재선택, 7)
									LV_GetText(목표Y,아템_현재선택, 8)
									LV_GetText(목표Z,아템_현재선택, 9)
									mem.write(0x00590770, 현재타겟OID, "UInt", aOffsets*)
									거리X := ABS(목표X - 좌표X)
									거리Y := ABS(목표Y - 좌표Y)
									좌표입력(목표X,목표Y,1)
									sleep,50
									SB_SetText(좌표X " " 시작X " " 좌표Y " " 시작Y ,5)
									if ( 마지막타겟OID != 현재타겟OID ) ; 그 선택된 몬스터가 새로운 몬스터라면
									{
										SB_SetText(좌표X " " 시작X " " 좌표Y " " 시작Y "1" ,5)
										keyclick("AltR")
										sleep,1000
										SB_SetText("새로운 먹자목표: " 현재타겟이름,2)
										마지막타겟OID := 현재타겟OID
										mem.writeString(0x005901E5, 현재타겟이름, "UTF-16", aOffsets*)
										시작X := 좌표X
										시작Y := 좌표Y
										시작Z := 좌표Z
										;if(거리X < 16 && 거리Y < 8)
										RunMemory("좌표이동")
										continue
									}
									else ; 그 선택된 몬스터가 새로운 몬스터가 아니라면 ;블랙리스트에 등록할지 말지 결정
									{
										if (근접체크 = 0) ;도착했다면
										{
											SB_SetText(좌표X " " 시작X " " 좌표Y " " 시작Y "2" ,5)
											SB_SetText( 현재타겟이름 " 위에 도착완료",2)
											MLS_delay := 0
											keyclick("AltR")
											sleep,100
											keyclick("Tab")
											sleep,100
											keyclick("Space")
											sleep,100
											keyclick("Space")
											sleep,100
											keyclick("Tab")
											sleep,100
											continue
										}
										else if (좌표X != 시작X && 좌표Y != 시작Y )
										{
											SB_SetText(좌표X " " 시작X " " 좌표Y " " 시작Y "3" ,5)
											SB_SetText(현재타겟이름 "근처에 가는중",2)

											MLS_delay := 0
											시작X := 좌표X
											시작Y := 좌표Y
											시작Z := 좌표Z
											continue
										}
										else if (좌표X = 시작X && 좌표Y = 시작Y && MLS_delay < 2) ;만약 2초간 몬스터와 거리 1 초과에 멈춰서있다면
										{
											SB_SetText(좌표X " " 시작X " " 좌표Y " " 시작Y "4" ,5)
											SB_SetText(현재타겟이름 "에 도달불가 " MLS_delay "/3",2)
											시작X := 좌표X
											시작Y := 좌표Y
											시작Z := 좌표Z
											MLS_delay++
											keyclick("Tab")
											sleep, 100
											keyclick("Tab")
											RunMemory("좌표이동")
											continue
										}
										else if (좌표X = 시작X && 좌표Y = 시작Y && MLS_delay = 2) ;만약 2초간 몬스터와 거리 1 초과에 멈춰서있다면
										{
											SB_SetText(좌표X " " 시작X " " 좌표Y " " 시작Y "5" ,5)
											SB_SetText(현재타겟이름 "에 도달불가 블랙리스트 등록",2)
											data := 현재타겟OID
											if (!IsDataInList(data, MonsterList))
												blacklist.Push(data)
											gui,listview,블랙리스트
											LV_add("",현재타겟OID)
											sleep, 50
											gui,listview,아이템리스트
											LV_Modify(0, "-Select")
											MLS_delay := 0
											continue
										}
										else
										{
											시작X := 좌표X
											시작Y := 좌표Y
											시작Z := 좌표Z
											continue
										}
										SB_SetText(좌표X " " 시작X " " 좌표Y " " 시작Y "6" ,5)

									}
									continue
								}
								else if (좌표갯수 > 0 && 자동이동여부 = 1)
								{
									gui,listview,좌표리스트
									LV_GetText(목표X, 좌표_현재선택, 4)
									LV_GetText(목표Y, 좌표_현재선택, 5)
									LV_GetText(목표Z, 좌표_현재선택, 6)
									좌표입력(목표X,목표Y,목표Z)
									거리X := ABS(목표X - 좌표X)
									거리Y := ABS(목표Y - 좌표Y)
									다음좌표 := 좌표_현재선택 + 1
									if (다음좌표 > 좌표갯수)
									{
										다음좌표 := 1
									}
									if (거리X <= 2 && 거리Y <= 2)
									{
										gui,listview,좌표리스트
										SB_SetText(좌표_현재선택 "번 좌표에 도착, 다음좌표 선택",2)
										LV_Modify(0,"-Select")
										LV_Modify(다음좌표,"Select")
										MLS_delay := 0
										시작X := 좌표X
										시작Y := 좌표Y
										시작Z := 좌표Z
										keyclick("Tab")
										sleep, 100
										keyclick("Tab")
										RunMemory("좌표이동")
										continue
									}
									else if (좌표X != 시작X && 좌표Y != 시작Y)
									{
										SB_SetText(좌표_현재선택 "번 좌표에 가는중",2)
										MLS_delay := 0
										시작X := 좌표X
										시작Y := 좌표Y
										시작Z := 좌표Z
										continue
									}
									else if (좌표X = 시작X && 좌표Y = 시작Y && MLS_delay < 3) ;만약 2초간 몬스터와 거리 1 초과에 멈춰서있다면
									{
										MLS_delay++
										SB_SetText(좌표_현재선택 "번 좌표에 도달불가 " MLS_delay "/3",2)
										시작X := 좌표X
										시작Y := 좌표Y
										시작Z := 좌표Z
										MLS_delay++
										keyclick("Tab")
										sleep, 100
										keyclick("Tab")
										RunMemory("좌표이동")
										continue
									}
									else if (좌표X = 시작X && 좌표Y = 시작Y && MLS_delay = 3) ;만약 2초간 몬스터와 거리 1 초과에 멈춰서있다면
									{
										gui,listview,좌표리스트
										MLS_delay := 0
										SB_SetText(좌표_현재선택 "번 좌표에 도달불가 " MLS_delay "/3",2)
										LV_Modify(0,"-Select")
										LV_Modify(다음좌표,"Select")
										keyclick("Tab")
										sleep, 100
										keyclick("Tab")
										RunMemory("좌표이동")
										continue
									}
									else
									{
										시작X := 좌표X
										시작Y := 좌표Y
										시작Z := 좌표Z
										continue
									}
									continue
								}
							}
							else
							{
								sleep,1000
								break
							}
						}
					}
					else if (CurrentMode = "배달하기") ;만약 "배달하기" 모드라면
					{
						SB_SetText("배달하기",1)
						loop,
						{
							if (CurrentMode = "배달하기") && (서버상태) && (Coin)
							{
								gosub, 아이템읽어오기
								if (아이템갯수["라스의깃"] < 2 || 아이템갯수["오란의깃"] < 2)
								{
									SB_SetText("라깃구매필요",2)
									라깃구매필요 := True
								}
								if (아이템갯수["식빵"] < 1 && 식빵구매여부 = 1 && 식빵사용제한 > 현재FP)
								{
									SB_SetText("식빵구매필요",2)
									식빵구매필요 := True
								}
								GALRID := mem.read(0x0058DAD4, "UInt", 0x178, 0x6F)
								GuiControl,, GALRID, % GALRID
								sleep,1
								맵번호 := mem.read(0x0058EB1C, "UInt", 0x10E)
								맵이름 := mem.readString(mem.getModuleBaseAddress("jelancia_core.dll")+0x44A28, 50, "UTF-16", 0xC)
								sleep,1

								if (맵번호 = 2 || 맵번호 = 208 || 맵번호 = 217 || 맵번호 = 214)
								{
									현재마을 := "로랜시아"
								}
								else if (맵번호 = 1002 || 맵번호 = 1208 || 맵번호 = 1217 || 맵번호 = 1214)
								{
									현재마을 := "에필로리아"
								}
								else if (맵번호 = 2002 || 맵번호 = 2208 || 맵번호 = 2217 || 맵번호 = 2214)
								{
									현재마을 := "세르니카"
								}

								if ((GALRID < 1000 ) && 라깃구매필요)
								{
									SB_SetText("갈리드가 부족합니다." , 2)
									return
								}
								else if (목적마을 = "" && 목적지 = "") ; 처음시작용
								{
									keyclick(길탐색책단축키)
									if (맵번호 = 2 || 맵번호 = 208 || 맵번호 = 217 || 맵번호 = 214)
									{
										현재마을 := "로랜시아"
										목적마을 := "로랜시아"
									}
									else if (맵번호 = 1002 || 맵번호 = 1208 || 맵번호 = 1217 || 맵번호 = 1214)
									{
										현재마을 := "에필로리아"
										목적마을 := "에필로리아"
									}
									else if (맵번호 = 2002 || 맵번호 = 2208 || 맵번호 = 2217 || 맵번호 = 2214)
									{
										현재마을 := "세르니카"
										목적마을 := "세르니카"
									}
									else
										목적마을 := "에필로리아"
									if (맵번호 = 208 || 맵번호 = 1208 || 맵번호 = 2208)
										목적지 := "목공소"
									else if (맵번호 = 217 || 맵번호 = 1217 || 맵번호 = 2217)
										목적지 := "우체국"
									else if (맵번호 = 214 || 맵번호 = 1214 || 맵번호 = 2214)
										목적지 := "퍼브"
									else
										목적지 := "목공소"
									SB_SetText("배달하기 처음목적지 " 목적마을 목적지,2)
									continue
								}
								else if (라깃구매필요)
								{
									if (목적마을 = "")
									{
										맵번호 := mem.read(0x0058EB1C, "UInt", 0x10E)
										if (맵번호 = 2)
											목적마을 := "로랜시아"
										else if (맵번호 = 1002)
											목적마을 := "에필로리아"
										else if (맵번호 = 2002)
											목적마을 := "세르니카"
										else
											목적마을 := "세르니카"
									}
									gosub, 배달라깃구매
								}
								else if (현재마을 != 목적마을)
								{
									if (길탐색책사용 && 현재FP > 140)
									{
										if (길탐색1번사용여부 = 1 && instr(길탐색1번목적지,목적마을)&& instr(길탐색1번목적지,목적지))
										{
											Search_Book(1)
											sleep, 300
										}
										else if (길탐색2번사용여부 = 1 && instr(길탐색2번목적지,목적마을)&& instr(길탐색2번목적지,목적지))
										{
											Search_Book(2)
											sleep, 300
										}
										else if (길탐색3번사용여부 = 1 && instr(길탐색3번목적지,목적마을)&& instr(길탐색3번목적지,목적지))
										{
											Search_Book(3)
											sleep, 300
										}
										else if (길탐색4번사용여부 = 1 && instr(길탐색4번목적지,목적마을)&& instr(길탐색4번목적지,목적지))
										{
											Search_Book(4)
											sleep, 300
										}
										else if (길탐색5번사용여부 = 1 && instr(길탐색5번목적지,목적마을)&& instr(길탐색5번목적지,목적지))
										{
											Search_Book(5)
											sleep, 300
										}
										sleep,700
										맵번호 := mem.read(0x0058EB1C, "UInt", 0x10E)
										sleep,1

										if (맵번호 = 2 || 맵번호 = 208 || 맵번호 = 217 || 맵번호 = 214)
										{
											현재마을 := "로랜시아"
										}
										else if (맵번호 = 1002 || 맵번호 = 1208 || 맵번호 = 1217 || 맵번호 = 1214)
										{
											현재마을 := "에필로리아"
										}
										else if (맵번호 = 2002 || 맵번호 = 2208 || 맵번호 = 2217 || 맵번호 = 2214)
										{
											현재마을 := "세르니카"
										}
										if (현재마을 = 목적마을)
											continue
									}
									SB_SetText(목적마을 " " 목적지 "이동중",2)
									if(Dimension>20000)
										차원:="감마"
									else if(Dimension>10000)
										차원:="베타"
									else if(Dimension<10000)
										차원:="알파"
									sleep, 1
									맵번호 := mem.read(0x0058EB1C, "UInt", 0x10E)
									sleep, 1
									if (오란의깃사용여부 = 1 && 오란의깃마을 = 목적마을) ;갈리드 아끼기 모드
									{
										if (IsDataInList(맵번호, 나가기가능맵))
										{
											gosub, 상점나가기
										}
										keyclick(오란의깃단축키)
										sleep, 100
									}
									맵번호 := mem.read(0x0058EB1C, "UInt", 0x10E)
									if (맵번호 = 2 || 맵번호 = 1002 || 맵번호 = 2002)
										continue
									else
										라깃사용하기(목적마을,차원)
									sleep, 1000
								}
								else if (현재마을 = 목적마을 && !instr(맵이름,목적지))
								{
									SB_SetText(목적마을 " " 목적지 "이동중",2)
									gosub, 배달상점이동세팅
									gosub, 배달상점가기
									continue
								}
								else if (현재마을 = 목적마을 && instr(맵이름,목적지))
								{
									SB_SetText(목적마을 " " 목적지 "도착",2)
									sleep,500
									KeyClick("Ctrl1") ; 배달수주
									sleep, 100
									if (NPC_MSG_ADR = "없음") || (NPC_MSG_ADR < 1)
									{
										sleep, 1000
										SetFormat, Integer, H
										startAddress := 0x00100000
										endAddress :=  0x00200000
										NPC_MSG_ADR := mem.processPatternScan(startAddress, endAddress, 0x44, 0xC5, 0xC1, 0xc9, 0xC4, 0xB3, 0x20, 0x00, 0x30, 0xBC, 0xEC, 0xB2) ; "안녕하세요!!" 검색
										SetFormat, Integer, D
										SB_SetText("NPC대화주소검색중" NPC_MSG_ADR,2)
										GuiControl,, NPC_MSG_ADR, %NPC_MSG_ADR%
										sleep, 100
									}
									if (NPC_MSG_ADR = "없음") || (NPC_MSG_ADR < 1)
									{
										sleep, 1000
										SetFormat, Integer, H
										startAddress := 0x00100000
										endAddress :=  0x00200000
										NPC_MSG_ADR := mem.processPatternScan(startAddress, endAddress, 0x48, 0xC5, 0x55, 0xB1, 0x58, 0xD5, 0x38, 0xC1, 0x94, 0xC6) ; "안녕하세요!!" 검색
										SetFormat, Integer, D
										SB_SetText("NPC대화주소검색중" NPC_MSG_ADR,2)
										GuiControl,, NPC_MSG_ADR, %NPC_MSG_ADR%
										sleep, 100
									}
									loop, 300
									{
										sleep, 1
										NPCMsg4bytes := mem.read(NPC_MSG_ADR, "UINT", aOffsets*)
										NPCMsg := mem.readString(NPC_MSG_ADR, 100, "UTF-16", aOffsets*)
										If (InStr(NPCMsg,"펍"))
										{
											목적지 := "퍼브"
										}
										else If (InStr(NPCMsg,"우체"))
										{
											목적지 := "우체국"
										}
										else If (InStr(NPCMsg,"목공"))
										{
											목적지 := "목공소"
										}
										If (InStr(NPCMsg,"로랜시아"))
										{
											목적마을 := "로랜시아"
										}
										else If (InStr(NPCMsg,"에필로리아"))
										{
											목적마을 := "에필로리아"
										}
										else If (InStr(NPCMsg,"세르니카"))
										{
											목적마을 := "세르니카"
										}
										If (InStr(NPCMsg,"쓰여"))
										{
											mem.writeString(NPC_MSG_ADR, "", "UTF-16", aOffsets*)
											sleep, 1
											KeyClick("K6")
											break
										}
										else If (InStr(NPCMsg,"에 가서"))
										{
											mem.writeString(NPC_MSG_ADR, "", "UTF-16", aOffsets*)
											sleep, 1
											KeyClick("K6")
										}
										else If (InStr(NPCMsg,"한가지"))
										{
											mem.writeString(NPC_MSG_ADR, "", "UTF-16", aOffsets*)
											sleep, 1
											KeyClick("K6")
											break
										}
										else if InStr(NPCMsg,"갈리드를 얻다") || InStr(NPCMsg,"숙련도 경험치")
										{
											mem.writeString(NPC_MSG_ADR, "", "UTF-16", aOffsets*)
											sleep, 1
											KeyClick("K6")
											sleep,1
											break
										}
										else If (InStr(NPCMsg,"이에요..."))
										{
											mem.writeString(NPC_MSG_ADR, "", "UTF-16", aOffsets*)
											sleep, 1
											KeyClick("K6")
										}
										else If (InStr(NPCMsg,"안녕하세요"))
										{
											mem.writeString(NPC_MSG_ADR, "", "UTF-16", aOffsets*)
											sleep, 1
											KeyClick("K6")
										}
										else If (InStr(NPCMsg,"아직도"))
										{
											mem.writeString(NPC_MSG_ADR, "", "UTF-16", aOffsets*)
											sleep, 1
											KeyClick("K6")
										}
										else If (NPCMsg4bytes = 3384854417)
										{
											mem.writeString(NPC_MSG_ADR, "", "UTF-16", aOffsets*)
											sleep, 1
											KeyClick("K6")
										}
										else If (InStr(NPCMsg,"어서"))
										{
											mem.writeString(NPC_MSG_ADR, "", "UTF-16", aOffsets*)
											sleep, 1
											KeyClick("K6")
										}
										else If (InStr(NPCMsg,"한가"))
										{
											mem.writeString(NPC_MSG_ADR, "", "UTF-16", aOffsets*)
											sleep, 1
											KeyClick("K6")
										}
										else If (InStr(NPCMsg,"늦으시"))
										{
											mem.writeString(NPC_MSG_ADR, "", "UTF-16", aOffsets*)
											sleep, 1
											KeyClick("K6")
										}
										else If (InStr(NPCMsg,"배달"))
										{
											mem.writeString(NPC_MSG_ADR, "", "UTF-16", aOffsets*)
											sleep, 1
											KeyClick("K6")
										}
										else If (InStr(NPCMsg,"완료"))
										{
											mem.writeString(NPC_MSG_ADR, "", "UTF-16", aOffsets*)
											sleep, 1
											KeyClick("K6")
										}
										else If (InStr(NPCMsg,"작지"))
										{
											mem.writeString(NPC_MSG_ADR, "", "UTF-16", aOffsets*)
											sleep, 1
											KeyClick("K6")
										}
										else If (InStr(NPCMsg,"감사합니다"))
										{
											mem.writeString(NPC_MSG_ADR, "", "UTF-16", aOffsets*)
											sleep, 1
											KeyClick("K6")
										}
										else If (InStr(NPCMsg,"여기"))
										{
											mem.writeString(NPC_MSG_ADR, "", "UTF-16", aOffsets*)
											sleep, 1
											KeyClick("K6")
										}
										else If (InStr(NPCMsg,"어디"))
										{
											mem.writeString(NPC_MSG_ADR, "", "UTF-16", aOffsets*)
											sleep, 1
											KeyClick("K6")
										}
										else If (InStr(NPCMsg,"이에요"))
										{
											Kmem.writeString(NPC_MSG_ADR, "", "UTF-16", aOffsets*)
											sleep, 1
											KeyClick("K6")
										}
										else
										{
											sleep, 1
											continue
										}
										sleep, 1

									}
									gosub, 배달상점이동세팅
									SB_SetText("다음목적지" 목적마을 목적지 ,2)
									sleep,500
								}
							}
							else
								break
						}
					}
					else if (CurrentMode = "포남자사" || CurrentMode = "포북자사") ;만약 특별한 "자사" 모드라면
					{
						loop,
						{
							if (CurrentMode = "포남자사" || CurrentMode = "포북자사") && (서버상태) && (Coin)
							{
								gui,submit,nohide
								sleep, 300
								맵번호 := mem.read(0x0058EB1C, "UInt", 0x10E)
								좌표X := mem.read(0x0058DAD4, "UInt", 0x10)
								좌표Y := mem.read(0x0058DAD4, "UInt", 0x14)
								좌표Z := mem.read(0x0058DAD4, "UInt", 0x18)
								gosub, 아이템읽어오기
								if (아이템갯수["라스의깃"] < 2 || 아이템갯수["오란의깃"] < 2)
								{
									SB_SetText("라깃구매필요",2)
									라깃구매필요 := True
								}
								if (아이템갯수["식빵"] < 1 && 식빵구매여부 = 1 && 식빵사용제한 > 현재FP)
								{
									SB_SetText("식빵구매필요",2)
									식빵구매필요 := True
								}
								gui,listview,몬스터리스트
								자사_현재선택 := LV_getnext(0)
								gui,listview,아이템리스트
								아템_현재선택 := LV_getnext(0)
								gui,listview,좌표리스트
								좌표_현재선택 := LV_GetNext(0)
								좌표갯수 := LV_GetCount()
								NPC_TALK_DELAY := A_TickCount - NPC_TALK_DELAYCOUNT
								설정된마을 := [4002]
								GALRID := mem.read(0x0058DAD4, "UInt", 0x178, 0x6F)
								GuiControl,, GALRID, % GALRID
								AttackStartCounter := A_TickCount
								if (무기수리필요 || 식빵구매필요 || 라깃구매필요 || (그레이드필요 && 자동그레이드 = True))
								{
									if !(IsDataInList(맵번호, 설정된마을))
									{
										if (IsDataInList(맵번호, 나가기가능맵)) ;마을의 베이커리 ; 마법상점 ; 안이라면
										{
											gosub, 상점나가기
											continue
										}
										else
										{
											마을 := "포프레스네"
											목적차원 := "베타"
											if (오란의깃사용여부 = 1 && 오란의깃마을 = 마을 )
											{
												keyclick(오란의깃단축키)
												sleep, 1000
												맵번호 := mem.read(0x0058EB1C, "UInt", 0x10E)
												if (IsDataInList(맵번호, 설정된마을))
													continue
											}
											라깃사용하기(마을,목적차원)
											continue
										}
									}
									else if (골드바판매여부 && GALRID < 1000000 && 아이템갯수["골드바"] > 0)
									{
										gosub, 골드바팔기
										continue
									}
									else if (골드바구매여부 && GALRID > 9600000 )
									{
										gosub, 골드바사기
										continue
									}
									else if (무기수리필요 || 식빵구매필요 || 라깃구매필요) && (GALRID < 100000)
									{
										gosub, CurrentMode_대기모드
										SB_SetText("갈리드가 부족합니다.",2)
										break
									}
									else if (무기수리필요)
									{
										목적마을 := "포프레스네"
										목적지 := "무기상점"
										동작방법 := "Repair"
										gosub, 무기수리
										continue
									}
									else if (식빵구매필요)
									{
										gosub, 식빵구매
										continue
									}
									else if (라깃구매필요)
									{
										gosub, 라깃구매
										continue
									}
									else if (그레이드필요 && GALRID > 1000000 && 아이템갯수["정령의보석"] > 10)
									{
										gosub, 그레이드하기
										continue
									}

								}
								else if (( CurrentMode = "포남자사" && 맵번호 != 4005 ) || ( CurrentMode = "포북자사" && 맵번호 != 4003 ))
								{
									IsMoving := mem.read(0x0058EB1C, "UInt", 0x174)
									if( 맵번호 = 4002 ) ; 마을이라면
									{
										if (IsMoving != 0)
										{
											continue
										}
										else if (CurrentMode = "포남자사")
										{
											SB_SetText("포남자사: 리노아호출중",2)
											호출할NPC := "리노아"
											호출할NPCOID존재여부 := CallNPC(호출할NPC)
											if(호출할NPCOID존재여부 = 1)
											{
												리노아호출입장()
												continue
											}
											else
											{
												SB_SetText("포남자사: 리노아에게 가는중",2)
												좌표입력(120,182,1)
												RunMemory("좌표이동")
												continue
											}
										}
										else if (CurrentMode = "포북자사" && IsMoving = 0)
										{
											keyclick("AltR")
											sleep, 100
											SB_SetText("포북자사: 포북가는중",2)
											좌표입력(172,15,1)
											RunMemory("좌표이동")
										}
										continue
									}
									else if (IsDataInList(맵번호, 나가기가능맵)) ;마을의 베이커리 ; 마법상점 ; 안이라면
									{
										gosub, 상점나가기
										continue
									}
									else
									{
										마을 := "포프레스네"
										목적차원 := "베타"
										라깃사용하기(마을,목적차원)
										continue
									}
								}
								else if ( NPC_TALK_DELAY > 60000 && ( CurrentMode = "포남자사" || CurrentMode = "포북자사" ) && 포레스트네자동대화 = 1 )
								{
									if (포레스트네자동대화딜레이 = "10분" )
										NPC대화반복시간 := 10
									else if (포레스트네자동대화딜레이 = "1분" )
										NPC대화반복시간 := 1
									else if (포레스트네자동대화딜레이 = "5분" )
										NPC대화반복시간 := 5
									else if (포레스트네자동대화딜레이 = "19분" )
										NPC대화반복시간 := 19
									else if (포레스트네자동대화딜레이 = "29분" )
										NPC대화반복시간 := 29
									NPC_TALK_DELAYCOUNT := A_TickCount
									NPC대화딜레이+=1
									guicontrol, ,NPC대화딜레이,%NPC대화딜레이%
									if (NPC대화딜레이>=NPC대화반복시간)
									{
										gosub, 포레스트네자동감응
									}
								}
								else if (자사_현재선택 != 0  && 자동사냥여부 = 1)
								{
									현재무기 := mem.read(0x0058DAD4, "UInt", 0x121)
									if (일무기 == 1 && 현재무기 == 0)
									{
										keyclick(1)
									}
									if ( CurrentMode = "포북자사" )
										mem.writeString(0x005901E5, "빛나는가루", "UTF-16", aOffsets*)
									else if ( CurrentMode = "포남자사" )
										mem.writeString(0x005901E5, "생명의콩", "UTF-16", aOffsets*)
									gui,listview,몬스터리스트
									lv_gettext(현재타겟이름,자사_현재선택,5)
									lv_gettext(현재타겟OID,자사_현재선택,6)
									lv_gettext(근접체크,자사_현재선택,12)
									공격여부 := mem.read(0x0058DAD4, "UInt", 0x178, 0xEB)
									if ( 마지막타겟OID != 현재타겟OID ) ; 그 선택된 몬스터가 새로운 몬스터라면
									{
										IsMoving := mem.read(0x0058EB1C, "UInt", 0x174)
										if (IsMoving != 0)
										{
											Keyclick("Tab")
											sleep, 100
											continue
										}
										SB_SetText("새로운 공격목표: " 현재타겟이름,2)
										마지막타겟OID := 현재타겟OID
										마지막타격번호 := mem.read(0x0058dad4,"UINT",0x1a5)
										mem.write(0x00590730, 현재타겟OID, "UInt", aOffsets*)
										mem.write(0x00584C2C, 현재타겟OID, "UInt", aOffsets*)
										시작X := 좌표X
										시작Y := 좌표Y
										시작Z := 좌표Z
										시작타격번호 := mem.read(0x0058dad4,"UINT",0x1a5)
										RunMemory("공격하기")
										continue
									}
									else ; 그 선택된 몬스터가 새로운 몬스터가 아니라면 ;블랙리스트에 등록할지 말지 결정
									{

										if (근접체크 = 1 && 공격여부 = 0) ;도착했다면
										{
											RunMemory("공격하기")
											AttackStartCounter := A_TickCount
										}
										else if (근접체크 = 1 && 공격여부 != 0) ;도착했다면
										{
											SB_SetText( 현재타겟이름 " 근처에 도착완료",2)
											MLS_delay := 0

											if (버스기사모드 = 0)
											{
												RecentWeapons := []
												abilityStates := []
												abilities[0] := {Name: "", Count: 0}
												abilities[1] := {Name: "", Count: 0}
												abilities[2] := {Name: "", Count: 0}
												abilities[3] := {Name: "", Count: 0}

												좀비여부 := 0
												무바여부 := 0
												공격여부 := 2
												AttackStartCounter := A_TickCount
												Loop,
												{
													gui, submit, nohide
													sleep, 1
													gui,listview,몬스터리스트
													lv_gettext(현재타겟OID,자사_현재선택,6)
													lv_gettext(근접체크,자사_현재선택,12)
													선택현황 := lv_getnext(0)
													if ( 마지막타겟OID != 현재타겟OID )
													{
														SB_SetText("기존몹소실",1)
														break
													}
													else if ( 선택현황 = 0 )
													{
														SB_SetText("선택없음",1)
														break
													}
													else if ( 근접체크 != 1 )
													{
														SB_SetText("몹이멀다",1)
														break
													}
													else if ( 공격여부 = 0 )
													{
														SB_SetText("공격안함",1)
														break
													}
													else if ( 수리필요여부 = 1 )
													{
														SB_SetText("수리필요",1)
														break
													}
													else
														SB_SetText("공격중 Z:" 좀비여부 ", W:" 무바여부,1)
													현재무기 := mem.read(0x0058DAD4, "UInt", 0x121)
													if (현재무기 != 0)
														TrackWeaponChange(현재무기)
													무바여부 := CheckTrackedWeapons()
													상승어빌 := mem.readString(상승어빌주소 + 0x64, 20, "UTF-16", aOffsets*)

													ZB_Delay := A_TickCount - AttackStartCounter
													if  (무바여부 >= 사용할무기수량)
													{
														무기수리필요여부확인 := 0
													}
													if (ZB_Delay > 5000)
													{
														if (좀비여부 = 0)
														{
															keyclick("AltR")
															sleep,1
															keyclick("AltR")
															gui,listview,몬스터리스트
															;Lv_modify(0,"-select")
															sleep,1
														}
														공격여부 := mem.read(0x0058DAD4, "UInt", 0x178, 0xEB)
														if  (무바여부 < 사용할무기수량)
														{
															SB_SetText("무바문제" 무기수리필요여부확인, 1)
															무기수리필요여부확인++
														}
														else
														{
															무기수리필요여부확인 := 0
															무기수리필요 := False
														}
														if (무기수리필요여부확인 > 10 && 주먹 = 0)
														{
															무기수리필요 := True
															guicontrol,,무기수리필요상태,%무기수리필요%
														}
														if (ZB_Delay > 10000)
														{
															if (좀비여부 = 0)
															{
																blacklist.push(마지막타겟OID)
																sleep,100
																keyclick("AltR")
																sleep,100
																keyclick("AltR")
															}
															else
															{
																좀비여부 := 0
																AttackStartCounter := A_TickCount
															}
														}
													}
													else if (IsWordInList(상승어빌, 공격어빌))
													{
														상승어빌값 := mem.read(상승어빌주소 + 0x264, "UInt", aOffsets*)
														상승어빌카운트 := mem.read(상승어빌주소 + 0x264 + 0x8, "UShort", aOffsets*)
														필요어빌카운트 := mem.read(상승어빌주소 + 0x264 + 0xA, "UShort", aOffsets*)
														raisedCount := UpdateAbility(상승어빌, 상승어빌값, 상승어빌카운트, 필요어빌카운트)
														좀비여부 += raisedCount
														SB_SetText(RecentWeapons[1] "," RecentWeapons[2] "," RecentWeapons[3] "," RecentWeapons[4] , 5)
														if (raisedCount > 0)
														{
															; 가장 최근에 오른 4가지 어빌 중에서 업데이트
															found := false
															for index, ability in abilities {
																if (ability.Name = 상승어빌) {
																	UpdateGUI(index, raisedCount)
																	found := true
																	break
																}
															}
															if (!found) {
																; 비어있는 어빌 슬롯 찾기 및 업데이트
																for index, ability in abilities {
																	if (ability.Name = "") {
																		abilities[index].Name := 상승어빌
																		UpdateGUI(index, raisedCount)
																		break
																	}
																}
															}
														}
													}
												}
											}
											continue
										}
										else if (좌표X != 시작X && 좌표Y != 시작Y)
										{
											SB_SetText(현재타겟이름 "근처에 가는중",2)
											MLS_delay := 0
											시작X := 좌표X
											시작Y := 좌표Y
											시작Z := 좌표Z
											continue
										}
										else if (좌표X = 시작X && 좌표Y = 시작Y && MLS_delay < 2) ;만약 2초간 몬스터와 거리 1 초과에 멈춰서있다면
										{
											SB_SetText(현재타겟이름 "에 도달불가 " MLS_delay "/1",2)
											시작X := 좌표X
											시작Y := 좌표Y
											시작Z := 좌표Z
											MLS_delay++
											RunMemory("공격하기")
											continue
										}
										else if (좌표X = 시작X && 좌표Y = 시작Y && MLS_delay >= 2) ;만약 2초간 몬스터와 거리 1 초과에 멈춰서있다면
										{
											keyclick("AltR")
											sleep,1
											SB_SetText(현재타겟이름 "에 도달불가 블랙리스트 등록",2)
											data := 현재타겟OID
											if (!IsDataInList(data, blacklist))
												blacklist.Push(data)
											sleep, 50
											gui,listview,몬스터리스트
											LV_Modify(0, "-Select")
											MLS_delay := 0
											continue
										}
										else
										{
											MLS_delay++
											시작X := 좌표X
											시작Y := 좌표Y
											시작Z := 좌표Z
										}
									}
									continue
								}
								else if (아템_현재선택 != 0  && 아템먹기여부 = 1)
								{
									현재무기 := mem.read(0x0058DAD4, "UInt", 0x121)
									;if (현재무기 != 0 && 현재무기 != 49153)
									;	RunMemory("무기탈거")
									gui,listview,아이템리스트
									lv_gettext(현재타겟이름,아템_현재선택,5)
									lv_gettext(현재타겟OID,아템_현재선택,6)
									lv_gettext(근접체크,아템_현재선택,12)
									LV_GetText(목표X, 아템_현재선택, 7)
									LV_GetText(목표Y, 아템_현재선택, 8)
									LV_GetText(목표Z, 아템_현재선택, 9)
									mem.write(0x00590770, 현재타겟OID, "UInt", aOffsets*)
									거리X := ABS(목표X - 좌표X)
									거리Y := ABS(목표Y - 좌표Y)
									좌표입력(목표X,목표Y,목표Z)
									if ( 마지막타겟OID != 현재타겟OID ) ; 그 선택된 몬스터가 새로운 몬스터라면
									{
										SB_SetText("새로운 먹자목표: " 현재타겟이름,2)
										마지막타겟OID := 현재타겟OID
										mem.writeString(0x005901E5, 현재타겟이름, "UTF-16", aOffsets*)
										시작X := 좌표X
										시작Y := 좌표Y
										시작Z := 좌표Z
										;if(거리X < 16 && 거리Y < 8)
										RunMemory("좌표이동")
										continue
									}
									else ; 그 선택된 몬스터가 새로운 몬스터가 아니라면 ;블랙리스트에 등록할지 말지 결정
									{
										if (근접체크 < 3)
 ;도착했다면
										{
											SB_SetText( 현재타겟이름 " 근처에 도착완료",2)
											MLS_delay := 0
											LV_GetText(대기카운트, 아템_현재선택, 12)
											대기카운트 := 대기카운트 + 1
											LV_Modify(아템_현재선택, "col11", 대기카운트)
											continue
										}
										else if (좌표X != 시작X && 좌표Y != 시작Y)
										{
											SB_SetText(현재타겟이름 "근처에 가는중",2)
											MLS_delay := 0
											시작X := 좌표X
											시작Y := 좌표Y
											시작Z := 좌표Z
											continue
										}
										else if (좌표X = 시작X && 좌표Y = 시작Y && MLS_delay < 2) ;만약 2초간 몬스터와 거리 1 초과에 멈춰서있다면
										{
											SB_SetText(현재타겟이름 "에 도달불가 " MLS_delay "/1",2)
											시작X := 좌표X
											시작Y := 좌표Y
											시작Z := 좌표Z
											MLS_delay++
											RunMemory("좌표이동")
											continue
										}
										else if (좌표X = 시작X && 좌표Y = 시작Y && MLS_delay = 2) ;만약 2초간 몬스터와 거리 1 초과에 멈춰서있다면
										{
											keyclick("AltR")
											sleep,1
											SB_SetText(현재타겟이름 "에 도달불가 블랙리스트 등록",2)
											data := 현재타겟OID
											if (!IsDataInList(data, MonsterList))
												blacklist.Push(data)
											gui,listview,블랙리스트
											LV_add("",현재타겟OID)
											sleep, 50
											gui,listview,아이템리스트
											LV_Modify(0, "-Select")
											MLS_delay := 0
											continue
										}
										else
										{
											시작X := 좌표X
											시작Y := 좌표Y
											시작Z := 좌표Z
										}
									}
									continue
								}
								else if (좌표갯수 > 0 && 자동이동여부 = 1)
								{
									현재무기 := mem.read(0x0058DAD4, "UInt", 0x121)
									;if (현재무기 != 0 && 현재무기 != 49153)
									;	RunMemory("무기탈거")
									gui,listview,좌표리스트
									LV_GetText(목표X, 좌표_현재선택, 4)
									LV_GetText(목표Y, 좌표_현재선택, 5)
									LV_GetText(목표Z, 좌표_현재선택, 6)
									좌표입력(목표X,목표Y,목표Z)
									거리X := ABS(목표X - 좌표X)
									거리Y := ABS(목표Y - 좌표Y)
									다음좌표 := 좌표_현재선택 + 1
									if (다음좌표 > 좌표갯수)
									{
										다음좌표 := 1
									}
									if (거리X <= 2 && 거리Y <= 2)
									{
										SB_SetText(좌표_현재선택 "번 좌표에 도착, 다음좌표 선택",2)
										LV_Modify(0,"-Select")
										LV_Modify(다음좌표,"Select")
										MLS_delay := 0
										시작X := 좌표X
										시작Y := 좌표Y
										시작Z := 좌표Z
										continue
									}
									else if (좌표X != 시작X && 좌표Y != 시작Y)
									{
										SB_SetText(좌표_현재선택 "번 좌표에 가는중",2)
										MLS_delay := 0
										시작X := 좌표X
										시작Y := 좌표Y
										시작Z := 좌표Z
										continue
									}
									else if (좌표X = 시작X && 좌표Y = 시작Y && MLS_delay < 3) ;만약 2초간 몬스터와 거리 1 초과에 멈춰서있다면
									{
										MLS_delay++
										SB_SetText(좌표_현재선택 "번 좌표에 도달불가 " MLS_delay "/3",2)
										시작X := 좌표X
										시작Y := 좌표Y
										시작Z := 좌표Z
										RunMemory("좌표이동")
										continue
									}
									else if (좌표X = 시작X && 좌표Y = 시작Y && MLS_delay = 3) ;만약 2초간 몬스터와 거리 1 초과에 멈춰서있다면
									{
										MLS_delay := 0
										keyclick("AltR")
										sleep,1
										gui,listview,좌표리스트
										좌표까지거리X := ABS(좌표X - 목표X)
										좌표까지거리Y := ABS(좌표Y - 목표Y)
										if (좌표까지거리X < 16 && 좌표까지거리Y < 8)
										{
											SB_SetText(좌표_현재선택 "번 좌표에 도달불가 " MLS_delay "/3",2)
											LV_Modify(0,"-Select")
											LV_Modify(다음좌표,"Select")
										}
										RunMemory("좌표이동")
										continue
									}
									else
									{
										시작X := 좌표X
										시작Y := 좌표Y
										시작Z := 좌표Z
									}
									continue
								}
							}
							else
								break

						}
					}
					else if (CurrentMode = "일반자사" )
					{
						loop,
						{
							if (CurrentMode = "일반자사") && (서버상태) && (Coin)
							{
								gui,submit,nohide
								sleep, 300
								맵번호 := mem.read(0x0058EB1C, "UInt", 0x10E)
								좌표X := mem.read(0x0058DAD4, "UInt", 0x10)
								좌표Y := mem.read(0x0058DAD4, "UInt", 0x14)
								좌표Z := mem.read(0x0058DAD4, "UInt", 0x18)
								gosub, 아이템읽어오기
								if (아이템갯수["라스의깃"] < 2 || 아이템갯수["오란의깃"] < 2)
								{
									SB_SetText("라깃구매필요",2)
									라깃구매필요 := True
								}
								if (아이템갯수["식빵"] < 1 && 식빵구매여부 = 1 && 식빵사용제한 > 현재FP)
								{
									SB_SetText("식빵구매필요",2)
									식빵구매필요 := True
								}
								gui,listview,몬스터리스트
								자사_현재선택 := LV_getnext(0)
								gui,listview,아이템리스트
								아템_현재선택 := LV_getnext(0)
								gui,listview,좌표리스트
								좌표_현재선택 := LV_GetNext(0)
								좌표갯수 := LV_GetCount()
								NPC_TALK_DELAY := A_TickCount - NPC_TALK_DELAYCOUNT
								설정된마을 := [4002]
								GALRID := mem.read(0x0058DAD4, "UInt", 0x178, 0x6F)
								GuiControl,, GALRID, % GALRID
								AttackStartCounter := A_TickCount
								if (자사_현재선택 != 0  && 자동사냥여부 = 1)
								{
									현재무기 := mem.read(0x0058DAD4, "UInt", 0x121)
									if (일무기 == 1 && 현재무기 == 0)
									{
										keyclick(1)
									}
									gui,listview,몬스터리스트
									lv_gettext(현재타겟이름,자사_현재선택,5)
									lv_gettext(현재타겟OID,자사_현재선택,6)
									lv_gettext(근접체크,자사_현재선택,12)
									공격여부 := mem.read(0x0058DAD4, "UInt", 0x178, 0xEB)
									if ( 마지막타겟OID != 현재타겟OID ) ; 그 선택된 몬스터가 새로운 몬스터라면
									{
										IsMoving := mem.read(0x0058EB1C, "UInt", 0x174)
										if (IsMoving != 0)
										{
											Keyclick("Tab")
											sleep, 100
											continue
										}
										SB_SetText("새로운 공격목표: " 현재타겟이름,2)
										마지막타겟OID := 현재타겟OID
										몬스터소탕[현재타겟이름] := (몬스터소탕[현재타겟이름] ? 몬스터소탕[현재타겟이름] + 1 : 1)
										SB_SetTexT(현재타겟이름 ":" 몬스터소탕[현재타겟이름] "소탕",1)
										마지막타격번호 := mem.read(0x0058dad4,"UINT",0x1a5)
										mem.write(0x00590730, 현재타겟OID, "UInt", aOffsets*)
										mem.write(0x00584C2C, 현재타겟OID, "UInt", aOffsets*)
										시작X := 좌표X
										시작Y := 좌표Y
										시작Z := 좌표Z
										시작타격번호 := mem.read(0x0058dad4,"UINT",0x1a5)
										RunMemory("공격하기")
										continue
									}
									else ; 그 선택된 몬스터가 새로운 몬스터가 아니라면 ;블랙리스트에 등록할지 말지 결정
									{
										현재무기 := mem.read(0x0058DAD4, "UInt", 0x121)
										if (현재무기 = 45057 || 현재무기 = 45058) ;활
										{
											if (공격여부 = 0)
											{
												RunMemory("공격하기")
											}
											continue
										}
										else if (근접체크 = 1 && 공격여부 = 0) ;도착했다면
										{
											RunMemory("공격하기")
											AttackStartCounter := A_TickCount
										}
										else if (근접체크 = 1 && 공격여부 != 0) ;도착했다면
										{
											SB_SetText( 현재타겟이름 " 근처에 도착완료",2)
											MLS_delay := 0

											if (버스기사모드 = 0)
											{
												RecentWeapons := []
												abilityStates := []
												abilities[0] := {Name: "", Count: 0}
												abilities[1] := {Name: "", Count: 0}
												abilities[2] := {Name: "", Count: 0}
												abilities[3] := {Name: "", Count: 0}

												좀비여부 := 0
												무바여부 := 0
												공격여부 := 2
												AttackStartCounter := A_TickCount
												Loop,
												{
													gui, submit, nohide
													sleep, 1
													gui,listview,몬스터리스트
													lv_gettext(현재타겟OID,자사_현재선택,6)
													lv_gettext(근접체크,자사_현재선택,12)
													선택현황 := lv_getnext(0)
													if ( 마지막타겟OID != 현재타겟OID )
													{
														SB_SetText("기존몹소실",1)
														break
													}
													else if ( 선택현황 = 0 )
													{
														SB_SetText("선택없음",1)
														break
													}
													else if ( 근접체크 != 1 )
													{
														SB_SetText("몹이멀다",1)
														break
													}
													else if ( 공격여부 = 0 )
													{
														SB_SetText("공격안함",1)
														break
													}
													else if ( 수리필요여부 = 1 )
													{
														SB_SetText("수리필요",1)
														break
													}
													else
														SB_SetText("공격중 Z:" 좀비여부 ", W:" 무바여부,1)
													현재무기 := mem.read(0x0058DAD4, "UInt", 0x121)
													if (현재무기 != 0)
														TrackWeaponChange(현재무기)
													무바여부 := CheckTrackedWeapons()
													상승어빌 := mem.readString(상승어빌주소 + 0x64, 20, "UTF-16", aOffsets*)

													ZB_Delay := A_TickCount - AttackStartCounter
													if  (무바여부 >= 사용할무기수량)
													{
														무기수리필요여부확인 := 0
													}
													if (ZB_Delay > 5000)
													{
														if (좀비여부 = 0)
														{
															keyclick("AltR")
															sleep,1
															keyclick("AltR")
															gui,listview,몬스터리스트
															;Lv_modify(0,"-select")
															sleep,1
														}
														공격여부 := mem.read(0x0058DAD4, "UInt", 0x178, 0xEB)
														if  (무바여부 < 사용할무기수량)
														{
															SB_SetText("무바문제" 무기수리필요여부확인, 1)
															무기수리필요여부확인++
														}
														else
														{
															무기수리필요여부확인 := 0
															무기수리필요 := False
														}
														if (무기수리필요여부확인 > 10 && 주먹 = 0)
														{
															무기수리필요 := True
															guicontrol,,무기수리필요상태,%무기수리필요%
														}
														if (ZB_Delay > 10000)
														{
															if (좀비여부 = 0)
															{
																blacklist.push(마지막타겟OID)
																sleep,100
																keyclick("AltR")
																sleep,100
																keyclick("AltR")
															}
															else
															{
																좀비여부 := 0
																AttackStartCounter := A_TickCount
															}
														}
													}
													else if (IsWordInList(상승어빌, 공격어빌))
													{
														상승어빌값 := mem.read(상승어빌주소 + 0x264, "UInt", aOffsets*)
														상승어빌카운트 := mem.read(상승어빌주소 + 0x264 + 0x8, "UShort", aOffsets*)
														필요어빌카운트 := mem.read(상승어빌주소 + 0x264 + 0xA, "UShort", aOffsets*)
														raisedCount := UpdateAbility(상승어빌, 상승어빌값, 상승어빌카운트, 필요어빌카운트)
														좀비여부 += raisedCount
														SB_SetText(RecentWeapons[1] "," RecentWeapons[2] "," RecentWeapons[3] "," RecentWeapons[4] , 5)
														if (raisedCount > 0)
														{
															; 가장 최근에 오른 4가지 어빌 중에서 업데이트
															found := false
															for index, ability in abilities {
																if (ability.Name = 상승어빌) {
																	UpdateGUI(index, raisedCount)
																	found := true
																	break
																}
															}
															if (!found) {
																; 비어있는 어빌 슬롯 찾기 및 업데이트
																for index, ability in abilities {
																	if (ability.Name = "") {
																		abilities[index].Name := 상승어빌
																		UpdateGUI(index, raisedCount)
																		break
																	}
																}
															}
														}
													}
												}
											}
											continue
										}
										else if (좌표X != 시작X && 좌표Y != 시작Y)
										{
											SB_SetText(현재타겟이름 "근처에 가는중",2)
											MLS_delay := 0
											시작X := 좌표X
											시작Y := 좌표Y
											시작Z := 좌표Z
											continue
										}
										else if (좌표X = 시작X && 좌표Y = 시작Y && MLS_delay < 2) ;만약 2초간 몬스터와 거리 1 초과에 멈춰서있다면
										{
											SB_SetText(현재타겟이름 "에 도달불가 " MLS_delay "/1",2)
											시작X := 좌표X
											시작Y := 좌표Y
											시작Z := 좌표Z
											MLS_delay++
											RunMemory("공격하기")
											continue
										}
										else if (좌표X = 시작X && 좌표Y = 시작Y && MLS_delay >= 2) ;만약 2초간 몬스터와 거리 1 초과에 멈춰서있다면
										{
											keyclick("AltR")
											sleep,1
											SB_SetText(현재타겟이름 "에 도달불가 블랙리스트 등록",2)
											data := 현재타겟OID
											if (!IsDataInList(data, blacklist))
												blacklist.Push(data)
											sleep, 50
											gui,listview,몬스터리스트
											LV_Modify(0, "-Select")
											MLS_delay := 0
											continue
										}
										else
										{
											MLS_delay++
											시작X := 좌표X
											시작Y := 좌표Y
											시작Z := 좌표Z
										}
									}
									continue
								}
								else if (아템_현재선택 != 0  && 아템먹기여부 = 1)
								{
									현재무기 := mem.read(0x0058DAD4, "UInt", 0x121)
									;if (현재무기 != 0 && 현재무기 != 49153)
									;	RunMemory("무기탈거")
									gui,listview,아이템리스트
									lv_gettext(현재타겟이름,아템_현재선택,5)
									lv_gettext(현재타겟OID,아템_현재선택,6)
									lv_gettext(근접체크,아템_현재선택,12)
									LV_GetText(목표X, 아템_현재선택, 7)
									LV_GetText(목표Y, 아템_현재선택, 8)
									LV_GetText(목표Z, 아템_현재선택, 9)
									mem.write(0x00590770, 현재타겟OID, "UInt", aOffsets*)
									거리X := ABS(목표X - 좌표X)
									거리Y := ABS(목표Y - 좌표Y)
									좌표입력(목표X,목표Y,목표Z)
									if ( 마지막타겟OID != 현재타겟OID ) ; 그 선택된 몬스터가 새로운 몬스터라면
									{
										SB_SetText("새로운 먹자목표: " 현재타겟이름,2)
										마지막타겟OID := 현재타겟OID

										mem.writeString(0x005901E5, 현재타겟이름, "UTF-16", aOffsets*)
										시작X := 좌표X
										시작Y := 좌표Y
										시작Z := 좌표Z
										;if(거리X < 16 && 거리Y < 8)
										RunMemory("좌표이동")
										continue
									}
									else ; 그 선택된 몬스터가 새로운 몬스터가 아니라면 ;블랙리스트에 등록할지 말지 결정
									{
										if (근접체크 < 3)
 ;도착했다면
										{
											SB_SetText( 현재타겟이름 " 근처에 도착완료",2)
											MLS_delay := 0
											LV_GetText(대기카운트, 아템_현재선택, 12)
											대기카운트 := 대기카운트 + 1
											LV_Modify(아템_현재선택, "col11", 대기카운트)
											continue
										}
										else if (좌표X != 시작X && 좌표Y != 시작Y)
										{
											SB_SetText(현재타겟이름 "근처에 가는중",2)
											MLS_delay := 0
											시작X := 좌표X
											시작Y := 좌표Y
											시작Z := 좌표Z
											continue
										}
										else if (좌표X = 시작X && 좌표Y = 시작Y && MLS_delay < 2) ;만약 2초간 몬스터와 거리 1 초과에 멈춰서있다면
										{
											SB_SetText(현재타겟이름 "에 도달불가 " MLS_delay "/1",2)
											시작X := 좌표X
											시작Y := 좌표Y
											시작Z := 좌표Z
											MLS_delay++
											RunMemory("좌표이동")
											continue
										}
										else if (좌표X = 시작X && 좌표Y = 시작Y && MLS_delay = 2) ;만약 2초간 몬스터와 거리 1 초과에 멈춰서있다면
										{
											keyclick("AltR")
											sleep,1
											SB_SetText(현재타겟이름 "에 도달불가 블랙리스트 등록",2)
											data := 현재타겟OID
											if (!IsDataInList(data, MonsterList))
												blacklist.Push(data)
											gui,listview,블랙리스트
											LV_add("",현재타겟OID)
											sleep, 50
											gui,listview,아이템리스트
											LV_Modify(0, "-Select")
											MLS_delay := 0
											continue
										}
										else
										{
											시작X := 좌표X
											시작Y := 좌표Y
											시작Z := 좌표Z
										}
									}
									continue
								}
								else if (몬스터소탕["스톤고렘"] >= 31 && 특오자동교환여부 = 1)
								{
									특오교환:
									몬스터소탕["스톤고렘"] := 0
									book := 6
									KeyClick(Book)
									sleep, 100
									맵번호 := mem.read(0x0058EB1C, "UInt", 0x10E)
									Num := 3 ;길탐수련 - 기본 길탐번호 변경을 원하면 여기를 수정 1,2,3,4,5 중 한개 입력
									if (맵번호 != 269)
									Search_Book(Num)
									sleep, 1000
									CallNPC("성검사")
									sleep, 1000
									MouseClick(400,324)
									loop, 15
									{
										keyclick("K6")
										sleep, 100
									}
									 mem.read(0x0058DAD0, "UInt", 0xC, 0x10, 0x8, 0xA0)
									if formnumber != 0
									{
										loop, 15
										{
											keyclick("K6")
											sleep, 100
										}
									}
									MouseClickRightButton(400,300)
									sleep, 1000
									Num := 4 ;길탐수련 - 기본 길탐번호 변경을 원하면 여기를 수정 1,2,3,4,5 중 한개 입력
									Search_Book(Num)
									continue
								}
								else if (좌표갯수 > 0 && 자동이동여부 = 1)
								{
									현재무기 := mem.read(0x0058DAD4, "UInt", 0x121)
									;if (현재무기 != 0 && 현재무기 != 49153)
									;	RunMemory("무기탈거")
									gui,listview,좌표리스트
									LV_GetText(목표X, 좌표_현재선택, 4)
									LV_GetText(목표Y, 좌표_현재선택, 5)
									LV_GetText(목표Z, 좌표_현재선택, 6)
									좌표입력(목표X,목표Y,목표Z)
									거리X := ABS(목표X - 좌표X)
									거리Y := ABS(목표Y - 좌표Y)
									다음좌표 := 좌표_현재선택 + 1
									if (다음좌표 > 좌표갯수)
									{
										다음좌표 := 1
									}
									if (거리X <= 2 && 거리Y <= 2)
									{
										SB_SetText(좌표_현재선택 "번 좌표에 도착, 다음좌표 선택",2)
										LV_Modify(0,"-Select")
										LV_Modify(다음좌표,"Select")
										MLS_delay := 0
										시작X := 좌표X
										시작Y := 좌표Y
										시작Z := 좌표Z
										continue
									}
									else if (좌표X != 시작X && 좌표Y != 시작Y)
									{
										SB_SetText(좌표_현재선택 "번 좌표에 가는중",2)
										MLS_delay := 0
										시작X := 좌표X
										시작Y := 좌표Y
										시작Z := 좌표Z
										continue
									}
									else if (좌표X = 시작X && 좌표Y = 시작Y && MLS_delay < 3) ;만약 2초간 몬스터와 거리 1 초과에 멈춰서있다면
									{
										MLS_delay++
										SB_SetText(좌표_현재선택 "번 좌표에 도달불가 " MLS_delay "/3",2)
										시작X := 좌표X
										시작Y := 좌표Y
										시작Z := 좌표Z
										RunMemory("좌표이동")
										continue
									}
									else if (좌표X = 시작X && 좌표Y = 시작Y && MLS_delay = 3) ;만약 2초간 몬스터와 거리 1 초과에 멈춰서있다면
									{
										MLS_delay := 0
										keyclick("AltR")
										sleep,1
										gui,listview,좌표리스트
										좌표까지거리X := ABS(좌표X - 목표X)
										좌표까지거리Y := ABS(좌표Y - 목표Y)
										if (좌표까지거리X < 16 && 좌표까지거리Y < 8)
										{
											SB_SetText(좌표_현재선택 "번 좌표에 도달불가 " MLS_delay "/3",2)
											LV_Modify(0,"-Select")
											LV_Modify(다음좌표,"Select")
										}
										RunMemory("좌표이동")
										continue
									}
									else
									{
										시작X := 좌표X
										시작Y := 좌표Y
										시작Z := 좌표Z
									}
									continue
								}
								else
									SB_SetText("일반자사오류발생",2)
							}
							else
								break
						}
					}
					else
						break
				}
				else
					break
			}
		}
		;}
		;{ 게임이 비정상이라면
		else if !(서버상태) && (자동재접속사용여부 = 1)
		{
			SB_SetText("자동재접속시작",2)
			인벤토리 := mem.read(0x0058DAD4, "UInt", 0x178, 0xBE, 0x14)
			if !(Coin)
			{
				continue
			}
			if !(인벤토리 > 0 && 인벤토리 <= 50)
			{
				SB_SetText("비정상",4)
				STOPSIGN := true
				서버상태 := False
			}
			Server := mem.read(0x0058DAD0, "UChar", 0xC, 0x8, 0x8, 0x6C)
			재접속횟수++
			FormatTime, CurrentTime,, HH:mm  ; 현재 시간을 HH:mm 형식으로 가져옵니다.
			guicontrol,, 재접속횟수기록, %재접속횟수%회 마지막재접속: %CurrentTime%
			Process, Exist, %TargetPID%
			if ErrorLevel
			{
				SB_SetText("단순재접속",2)
				ElanciaStep := 4
			}
			else if (Server = 1 || Server = 0) && (ElanciaStep != 4 || ElanciaStep != 5)
			{
				ElanciaStep := 4
			}
			else
			{
				SB_SetText("일랜완전재시작",2)
				ElanciaStep := 1
			}

			Loop,
			{
				인벤토리 := mem.read(0x0058DAD4, "UInt", 0x178, 0xBE, 0x14)
				if !(인벤토리 > 0 && 인벤토리 <= 50)
				{
					서버상태 := False
				}
				else if (인벤토리 > 0 && 인벤토리 <= 50)
				{
					서버상태 := True
					gosub, 기본설정적용
					break
				}
				sleep,1000
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
					SB_SetText("일랜실행중", 1)
					SB_SetText("NEXON플레이-일랜시아 실행시도", 2)
					run, ngm://launch/ -mode:pluglaunch -game:74276 -locale:KR
					Sleep, 10000
					ElanciaStep := 3
				}
				Else If (ElanciaStep = 3)
				{
					SB_SetText("서버접속중", 1)
					ControlGetText, Patch, Static2, Elancia
					sb_settext("서버메시지 - " Patch,2)
					IfInString,Patch,일랜시아 서버에 연결할 수 없습니다.
					{
						SB_SetText("서버접속실패", 1)
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
					WinGetTitle, tempTitle, ahk_pid %TargetPID%
					IfWinNotExist, %tempTitle%
					{
						ElanciaStep := 1
						Continue
					}
					SB_SetText("서버선택중", 1)
					sleep, 1000
					keyclick("Enter")
					mem := new _ClassMemory("ahk_pid " 0, "", hProcessCopy)
					mem := new _ClassMemory("ahk_pid " TargetPID, "", hProcessCopy)
					Server := mem.read(0x0058DAD0, "UChar", 0xC, 0x8, 0x8, 0x6C)
					gosub, 기본메모리쓰기
					if ( Server = 0 )
					{
						if (메인캐릭터서버 = "엘")
							MouseClick(299,248)
						else if (메인캐릭터서버 = "테스")
							MouseClick(299,273)
						ElanciaStep := 5
						MouseClick(365,384)
						sleep, 2000
					}
					else
					{
						ElanciaStep := 5
						sleep, 100
					}
					sleep, 100
				}
				Else If (ElanciaStep = 5) ; 캐릭터선택
				{
					WinGetTitle, tempTitle, ahk_pid %TargetPID%
					IfWinNotExist, %tempTitle%
					{
						ElanciaStep := 1
						Continue
					}
					SB_SetText("캐릭선택중", 1)
					sleep, 5000
					WinGetTitle, tempTitle, ahk_pid %TargetPID%
					sleep, 1000
					캐릭선택X := 460
					캐릭선택Y := 184 + 18 * 메인캐릭터순서
					MouseDoubleClickLeftButton(캐릭선택X,캐릭선택Y)

					ElanciaStep := 6
				}
				Else If (ElanciaStep = 6) ;접속여부 확인
				{
					WinGetTitle, tempTitle, ahk_pid %TargetPID%
					IfWinNotExist, %tempTitle%
					{
						ElanciaStep := 1
						Continue
					}
					SB_SetText("접속확인중", 1)
					WinGetTitle,newElanciaTitle,ahk_pid %TargetPID%
					ServerConnectionCheck := mem.readString(0x0017E574, 40, "UTF-16", aOffsets*)
					SB_SetText("newElanciaTitle:" newElanciaTitle, "TargetTitle:" TargetTitle, 2)
					Server := jelan.read(0x0058DAD0, "UChar", 0xC, 0x10, 0x8, 0x36C)
					인벤토리 := mem.read(0x0058DAD4, "UInt", 0x178, 0xBE, 0x14)
					IfInString,ServerConnectionCheck,서버와의 연결이
					{
						mem.writeString(0x0017E574, "", "UTF-16", aOffsets*)
						SB_SetText(ServerConnectionCheck, 2)
						sleep, 2000
						ControlSend, , {Enter}, ahk_pid %targetPid%
						ControlSend, , {Enter}, ahk_pid %targetPid%
						ElanciaStep := 4
						sleep, 5000
					}
					else IfInString,ServerConnectionCheck,오랜 시간 아무것도
					{
						mem.writeString(0x0017E574, "", "UTF-16", aOffsets*)
						SB_SetText(ServerConnectionCheck, 2)
						sleep, 2000
						ControlSend, , {Enter}, ahk_pid %targetPid%
						ControlSend, , {Enter}, ahk_pid %targetPid%
						ElanciaStep := 5
						sleep, 5000
					}
					else IfInString,ServerConnectionCheck,에어본게이트
					{
						mem.writeString(0x0017E574, "", "UTF-16", aOffsets*)
						SB_SetText(ServerConnectionCheck, 2)
						sleep, 1000
						ControlSend, , {Enter}, ahk_pid %targetPid%
						ControlSend, , {Enter}, ahk_pid %targetPid%
						ElanciaStep := 5
						sleep, 5000
					}
					else IfInString,ServerConnectionCheck,일랜시아 서버에
					{
						mem.writeString(0x0017E574, "", "UTF-16", aOffsets*)
						SB_SetText(ServerConnectionCheck, 2)
						sleep, 1000
						ControlSend, , {Enter}, ahk_pid %targetPid%
						ControlSend, , {Enter}, ahk_pid %targetPid%
						ElanciaStep := 5
						sleep, 5000
					}
					else IfInString,ServerConnectionCheck,에어본
					{
						mem.writeString(0x0017E574, "", "UTF-16", aOffsets*)
						SB_SetText(ServerConnectionCheck, 2)
						sleep, 1000
						ControlSend, , {Enter}, ahk_pid %targetPid%
						ControlSend, , {Enter}, ahk_pid %targetPid%
						ElanciaStep := 5
						sleep, 5000
					}
					else
						ElanciaStep := 4
				}
				else if (인벤토리 > 0 && 인벤토리 <= 50)
				{
					SB_SetText("newElanciaTitle:" newElanciaTitle, "TargetTitle:" TargetTitle, 2)
					ElanciaStep := "접속완료"
					SB_SetText("접속완료", 1)
					서버상태 := True
					gosub, 기본설정적용
					break
				}
				if (newElanciaTitle = TargetTitle && Server = 0)
				{
					SB_SetText("newElanciaTitle:" newElanciaTitle, "TargetTitle:" TargetTitle, 2)
					ElanciaStep := "접속완료"
					SB_SetText("접속완료", 1)
					서버상태 := True
					gosub, 기본설정적용
					break
				}
			}
		}
		;}
	}
	SB_SetText("코드끝",1)
return
;}

;{			 ; 4번 스레드

메모리검색_기본: ;아이템먹는 자사용
;{
gosub, 기본정보읽기
sleep,1
if ((기존맵번호 != 맵번호 || 기존차원 != 차원) && (맵번호 != "" && 맵번호 != 0))
{
	;SB_SETtext("기존맵번호" 기존맵번호 "현재맵번호" 맵번호 ,2)
	기존맵번호 := 맵번호
	기존차원 := 차원
	SB_SetText("맵변경 감지",2)
	SB_SetText("맵변경 감지",4)
	Gui, listview, 좌표리스트
	LV_Delete()
	PlayerList := []
	Gui, listview, 플레이어리스트
	LV_Delete()
	MonsterList := []
	Gui, listview, 몬스터리스트
	LV_Delete()
	ItemList := []
	Gui, listview, 아이템리스트
	LV_Delete()
	Gui, ListView, NPC리스트
	LV_Delete()
	Gui, ListView, 고용상인리스트
	LV_Delete()
	Setting_Reload("NPC리스트")
	Setting_Reload("좌표리스트")
	Setting_Reload("고용상인리스트")
	stopsign := False
}
gosub, 아이템읽어오기
RM_Delay := A_TickCount - Read_Memory_Count
if (RM_Delay > 5000) || (자동사냥여부 = 1)
{
	Read_Memory_Count := A_TickCount
	gosub, 메모리검색_몬스터
		if (자동사냥여부 = 1)
		{
			gosub, 몬스터_선택
			sleep, 1
		}
	gosub, 메모리검색_플레이어
}
sleep, 1
if (아템먹기여부 = 1)
{
	if (CurrentMode = "광물캐기")
		gosub, 메모리검색_아이템_광산
	else
		gosub, 메모리검색_아이템
	gosub, 아이템_선택
	sleep, 1
}
gosub, 소각하기
sleep, 1
gosub, 은행보관
return
;}

메모리검색_몬스터:
;{
; Constants
AddressToCheck := 0x005420AC
ListGUI := "몬스터리스트"
gui,submit,nohide
; Initialize ListView
gui, listview, %ListGUI%

; Read memory and populate MonsterList
startAddress := 0x005907D4
endAddress := 0x00590800
while (startAddress <= endAddress)
{
    data := mem.read(startAddress, "UInt", aOffsets*)
    if (!IsDataInList(data, MonsterList))
        MonsterList.Push(data)
    startAddress += 4
}

좌표X := mem.read(0x0058DAD4, "UInt", 0x10)
좌표Y := mem.read(0x0058DAD4, "UInt", 0x14)
좌표Z := mem.read(0x0058DAD4, "UInt", 0x18)

for index, result in MonsterList
{
    resultHex := Format("0x{:08X}", result)
    addr := mem.read(resultHex, "UInt", aOffsets*)
	find_object_id := mem.read(result + 0x5E, "UInt",aOffsets*)
	find_object_id := Format("0x{:08X}", find_object_id)
	LV_Row := GetLVRowByResult(result)
	gui, listview, %ListGUI%
	LV_GetText(분류,LV_Row,1)
	if (addr != AddressToCheck)
    {
        MonsterList.RemoveAt(index)
		gui, listview, %ListGUI%
		LV_Delete(LV_Row)
        continue
    }
    find_x := mem.read(result + 0x0C, "UInt", aOffsets*)
	find_y := mem.read(result + 0x10, "UInt", aOffsets*)
	find_z := mem.read(result + 0x14, "UInt", aOffsets*)
	distanceXYZ := Abs(find_x - 좌표X) + Abs(find_y - 좌표Y) + Abs(find_z - 좌표Z) * 20
	find_name := mem.readString(mem.read(result + 0x62, "UInt", aOffsets*), 20, "UTF-16",aOffsets*)
	findMID := mem.read(result + 0x82, "UInt", aOffsets*)
	if (findMID = 111) || (맵번호 == 2 && findMID <= 650 && findMID >= 608)
	{
		continue
	}
	if (원거리타겟 = 1 && 원거리타겟아이디 = find_name)
	{
		guicontrol,,특수원거리타겟OID,%find_object_id%
	}
	kind := "알수없음"

	if (kind = "알수없음")
	{
		for index, PossibleKind in 이름이바뀌는존재들
		{
			if (findMID == PossibleKind)
			{
				kind := "기타"
				break
			}
		}
	}

	if (kind = "기타")
	{
		SB_SetText(findMID "가 기타라서 종료",5)
		continue
	}

	if (kind = "알수없음")
	{
		; 확실한 경로를 지정합니다.
		FileName := "MonsterList.ini"
		IniRead, SavedMonsterList, %FileName%, %맵번호%
		MonsterInfo := StrSplit(SavedMonsterList, "`n")

		for index, PossibleKind in MonsterInfo
		{
			fields := StrSplit(PossibleKind, ",")
			if (findMID == fields[2])
			{
				kind := "몬스터"
				break
			}
		}
	}

	if (kind = "알수없음")
	{
		for index, PossibleKind in 게임내고용상인들
		{
			if (instr(find_name, PossibleKind))
			{
				kind := "고용상인"
				continue
			}
		}
	}

	if (kind = "알수없음")
	{
		for index, PossibleKind in 게임내NPC이미지
		{
			if (findMID == PossibleKind)
			{
				kind := "NPC"
				break
			}
		}
	}

	if (kind = "알수없음")
	{
		for index, PossibleKind in 게임내NPC들
		{
			if (instr(find_name, PossibleKind))
			{
				kind := "NPC"
				break
			}
		}
	}

	if (kind = "알수없음")
	{
		kind := "몬스터"
		;Setting_RECORD("MonsterList", kind, 차원, 맵이름, 맵번호, find_name, find_object_id, find_x, find_y, find_z, 중요도, result, findMID)
	}

	if (LV_Row > 0)
	{
		gui, listview, %ListGUI%
		LV_Modify(LV_Row,"", kind, 차원, 맵이름, 맵번호, find_name, find_object_id, find_x, find_y, find_z, , , distanceXYZ ,findMID)
		continue
	}

	if (kind = "몬스터")
	{
		Find := False
		gui, listview, %ListGUI%
		loop, % LV_GetCount()
		{
			LV_GetText(기존OID,A_Index,6)
			if (기존OID = find_object_id )
			{
				Find := True
				CurrentRow := A_INdex
				break
			}
		}
		if !(Find)
		{
			LV_Add("", kind, 차원, 맵이름, 맵번호, find_name, find_object_id, find_x, find_y, find_z, resultHex, , distanceXYZ ,findMID)
		}
		else
		{
			LV_Modify(CurrentRow, "", kind, 차원, 맵이름, 맵번호, find_name, find_object_id, find_x, find_y, find_z, resultHex, , distanceXYZ ,findMID)
		}
		continue
	}
	else if (kind = "NPC")
	{
		Find := False
		Gui, ListView, NPC리스트
		loop, % LV_GetCount()
		{
			LV_GetText(기존NPC차원,A_Index,2)
			LV_GetText(기존NPC맵번호,A_Index,4)
			LV_GetText(기존NPC이름,A_Index,5)
			LV_GetText(기존NPCOID,A_Index,6)
			if (기존NPC맵번호 = 맵번호 && 기존NPC차원 = 차원 && 기존NPC이름 = find_name && 기존NPCOID = find_object_id )
			{
				Find := True
				break
			}
			else if(기존NPC맵번호 = 맵번호 && 기존NPC차원 = 차원 && 기존NPC이름 = find_name && 기존NPCOID != find_object_id)
			{
				gosub, 서버점검후OID변경감지
			}
		}
		if !(Find)
		{
			SB_SetText("새로운NPC발견!" find_name,2)
			Setting_RECORD("NPC리스트", kind, 차원, 맵이름, 맵번호, find_name, find_object_id, find_x, find_y, find_z, 중요도, result, findMID)
			Gui, ListView, NPC리스트
			LV_Delete()
			Setting_Reload("NPC리스트")
		}
	}
	else if (kind = "고용상인")
	{
		Find := False
		Gui, ListView, 고용상인리스트
		loop, % LV_GetCount()
		{
			LV_GetText(기존NPC차원,A_Index,2)
			LV_GetText(기존NPC맵번호,A_Index,4)
			LV_GetText(기존NPC이름,A_Index,5)
			LV_GetText(기존NPCOID,A_Index,6)
			if (기존NPC맵번호 = 맵번호 && 기존NPC차원 = 차원 && 기존NPC이름 = find_name && 기존NPCOID = find_object_id )
			{
				Find := True
				break
			}
			else if(기존NPC맵번호 = 맵번호 && 기존NPC차원 = 차원 && 기존NPC이름 = find_name && 기존NPCOID != find_object_id)
			{
				gosub, 서버점검후OID변경감지
			}
		}
		if !(Find)
		{
			SB_SetText("새로운고용상인발견!" find_name,2)
			Setting_RECORD("고용상인리스트", kind, 차원, 맵이름, 맵번호, find_name, find_object_id, find_x, find_y, find_z, 중요도, result, findMID)
			Gui, ListView, 고용상인리스트
			LV_Delete()
			Setting_Reload("고용상인리스트")
		}
	}
}
Gui, listview, 몬스터리스트
i := 1
loop % LV_GetCount()
{
	LV_GetText(몬스터이름,i,5)
	LV_GetText(몬스터위치X,i,7)
	LV_GetText(몬스터위치Y,i,8)
	LV_GetText(몬스터위치Z,i,9)
	LV_GetText(몬스터주소,i,10)
	좌표X := mem.read(0x0058DAD4, "UInt", 0x10)
	좌표Y := mem.read(0x0058DAD4, "UInt", 0x14)
	거리X := ABS(좌표X-몬스터위치X)
	거리Y := ABS(좌표Y-몬스터위치Y)
	거리 := 거리X + 거리Y
	addr := mem.read(몬스터주소, "UInt", aOffsets*)
	find_name := mem.readString(mem.read(몬스터주소 + 0x62, "UInt", aOffsets*), 20, "UTF-16",aOffsets*)
	if ((addr != AddressToCheck) || ( find_name != 몬스터이름))
    {
		LV_Delete(i)
		continue
	}
	LV_Modify(i,"Col12",거리)
	i++
}
return
;}

몬스터_선택:
;{

; ListView에서 Col12 가 가장 낮은 값을 찾고, Col5가 WantedList에 포함되며, Col6가 BlackList에 포함되지 않는 항목을 선택합니다.
gui, listview, 몬스터리스트
LVCount := LV_GetCount()
LVSelect := LV_GetNext(0)
if ((LVSelect != 0) || !(LVCount = 0))
{
	LV_GetText(col5Value,LVSelect,5)
	if (!IsDataInList(col5Value, WantedMonsters) && WantedMonsterlength >= 1)
	{
		gui, listview, 몬스터리스트
		LV_Modify(0,"-Select")
	}
}

if (LVSelect != 0)
	return

lowestCol12Value := 999999 ; 초기 높은 값으로 설정
selectedRow := 0 ; 선택할 행 초기화
/*
	WantedItems
	WantedMonsters
	BlackList
	WantedItemlength := WantedItems.MaxIndex()
	WantedMonsterlength := WantedMonsters.MaxIndex()
	BlackListlength := BlackList.MaxIndex()
blackList := ["값1", "값2", "값3"] ; 블랙리스트 값들의 배열
wantedList := ["원하는값1", "원하는값2", "원하는값3"] ; 원하는 값들의 배열
*/

; ListView의 모든 행을 검색합니다
 ; ListView의 항목 수를 가져옵니다

WantedMonsterLength := 0 ; 기본값을 0으로 설정
if WantedMonsters.MaxIndex() ; 배열이 비어있지 않은 경우
    WantedMonsterLength := WantedMonsters.MaxIndex()

DisWantedMonsterLength := 0 ; 기본값을 0으로 설정
if DisWantedMonsters.MaxIndex() ; 배열이 비어있지 않은 경우
    DisWantedMonsterLength := DisWantedMonsters.MaxIndex()


Loop, %LVCount%
{
    thisRow := A_Index
    LV_GetText(col12Value, thisRow, 12) ; 현재 행의 Col12 값을 가져옵니다
    LV_GetText(col5Value, thisRow, 5) ; 현재 행의 Col5 값을 가져옵니다
    LV_GetText(col6Value, thisRow, 6) ; 현재 행의 Col6 값을 가져옵니다
	;SB_SetText("비교중" A_Index " " WantedMonsterlength, 5)
	SB_SETTEXT(WantedMonsterlength "/" DisWantedMonsterLength,5)
    ; Col12 값이 현재 가장 낮은 값보다 낮고, Col5 값이 WantedList에 포함되고, Col6 값이 BlackList에 없는 경우
    if ((col12Value < lowestCol12Value && !IsDataInList(col6Value, BlackList)) && ((IsDataInList(col5Value, WantedMonsters) && WantedMonsterLength >= 1) || WantedMonsterLength < 1 ) && ((!IsDataInList(col5Value, DisWantedMonsters) && DisWantedMonsterLength>=1) || DisWantedMonsterLength == 0))
	{
		lowestCol12Value := col12Value
		selectedRow := thisRow
    }
}

; 가장 낮은 Col12 값을 가지고 WantedList에 포함되며 BlackList에 없는 행을 선택합니다
if (selectedRow > 0)
{
    LV_Modify(selectedRow, "Select") ; 해당 행을 선택합니다
}

return
;}

IsNPCOIDCorret:
if (서버상태)
	return
서버점검후OID변경감지:
FileName := "NPCList.ini"
FileDelete, %FileName%
sleep,1
Gui, Listview, NPC리스트
LV_Delete()
FileName := "SellerList.ini"
FileDelete, %FileName%
sleep,1
Gui, Listview, 고용상인리스트
LV_Delete()
Setting_Reload("NPC리스트")
Setting_Reload("고용상인리스트")
SB_SetText("서버점검후 OID변경 감지됨",2)
return

메모리검색_플레이어:
;{
; Constants
AddressToCheck := 0x0053E38C
ListGUI := "플레이어리스트"
gui,submit,nohide
; Initialize ListView
gui, listview, %ListGUI%
; Read memory and populate PlayerList
startAddress := 0x00590B44
endAddress := 0x00590B80
while (startAddress <= endAddress)
{
    data := mem.read(startAddress, "UInt", aOffsets*)
    if (!IsDataInList(data, PlayerList))
        PlayerList.Push(data)
    startAddress += 4
}

좌표X := mem.read(0x0058DAD4, "UInt", 0x10)
좌표Y := mem.read(0x0058DAD4, "UInt", 0x14)
좌표Z := mem.read(0x0058DAD4, "UInt", 0x18)

for index, result in PlayerList
{
    resultHex := Format("0x{:08X}", result)
    addr := mem.read(resultHex, "UInt", aOffsets*)
	find_object_id := mem.read(result + 0x5E, "UInt",aOffsets*)
	find_object_id := Format("0x{:08X}", find_object_id)
	find_name := mem.readString(mem.read(result + 0x62, "UInt", aOffsets*), 20, "UTF-16",aOffsets*)
	findMID := mem.read(result + 0x82, "UInt", aOffsets*)
	LV_Row := GetLVRowByResult(result)
	LV_Row1 := GetLVRowByOID(find_object_id)
	kind := "플레이어"
	gui, listview, %ListGUI%
	LV_GetText(분류,LV_Row,1)
	if (addr != AddressToCheck)
    {
        PlayerList.RemoveAt(index)
		gui, listview, %ListGUI%
		LV_Delete(LV_Row)
        continue
    }
    find_x := mem.read(result + 0x0C, "UInt", aOffsets*)
	find_y := mem.read(result + 0x10, "UInt", aOffsets*)
	find_z := mem.read(result + 0x14, "UInt", aOffsets*)
	SetFormat, Integer, H
	find_object_id := mem.read(result + 0x5E, "UInt",aOffsets*)
	find_object_id := Format("0x{:08X}", find_object_id)
	SetFormat, Integer, D
	distanceXYZ := Abs(find_x - 좌표X) + Abs(find_y - 좌표Y) + Abs(find_z - 좌표Z) * 20
	if (리메듐타겟 = 1 && 리메듐타겟아이디 = find_name)
	{
		guicontrol,,특수리메듐타겟OID,%find_object_id%
	}
	if (LV_Row > 0)
	{
		gui, listview, %ListGUI%
		LV_Modify(LV_Row,"", kind, 차원, 맵이름, 맵번호, find_name, find_object_id, find_x, find_y, find_z, resultHex, 2, distanceXYZ ,findMID)
		continue
	}
	else if (LV_Row1 > 0)
	{
		gui, listview, %ListGUI%
		LV_Delete(LV_Row1)
		;LV_Modify(LV_Row1,"", kind, 차원, 맵이름, 맵번호, find_name, find_object_id, find_x, find_y, find_z, resultHex, 2, distanceXYZ ,findMID)
		continue
	}
	gui, listview, %ListGUI%
	LV_Add("", kind, 차원, 맵이름, 맵번호, find_name, find_object_id, find_x, find_y, find_z, resultHex, 2, distanceXYZ ,findMID)
}
Gui, listview, 플레이어리스트
i := 1
loop % LV_GetCount()
{
	LV_GetText(이름,i,5)
	LV_GetText(위치X,i,7)
	LV_GetText(위치Y,i,8)
	LV_GetText(위치Z,i,9)
	LV_GetText(주소,i,10)
	좌표X := mem.read(0x0058DAD4, "UInt", 0x10)
	좌표Y := mem.read(0x0058DAD4, "UInt", 0x14)
	거리X := ABS(좌표X-위치X)
	거리Y := ABS(좌표Y-위치Y)
	거리 := 거리X + 거리Y
	addr := mem.read(주소, "UInt", aOffsets*)
	find_name := mem.readString(mem.read(주소 + 0x62, "UInt", aOffsets*), 20, "UTF-16",aOffsets*)
	if ((addr != AddressToCheck) || (find_name != 이름))
    {
		LV_Delete(i)
		continue
	}
	LV_Modify(i,"Col12",거리)
	i++
}
return
;}

메모리검색_아이템:
;{
; Constants
AddressToCheck := 0x0053ECA4
ListGUI := "아이템리스트"

; Initialize ListView
gui, listview, %ListGUI%
; Read memory and populate ItemList
startAddress := 0x005908A4
endAddress := 0x00590900
while (startAddress <= endAddress)
{
    data := mem.read(startAddress, "UInt", aOffsets*)
    if (!IsDataInList(data, ItemList))
        ItemList.Push(data)
    startAddress += 4
}

좌표X := mem.read(0x0058DAD4, "UInt", 0x10)
좌표Y := mem.read(0x0058DAD4, "UInt", 0x14)
좌표Z := mem.read(0x0058DAD4, "UInt", 0x18)

for index, result in ItemList
{
    resultHex := Format("0x{:08X}", result)
    addr := mem.read(resultHex, "UInt", aOffsets*)
	find_object_id := mem.read(result + 0x5E, "UInt",aOffsets*)
	find_object_id := Format("0x{:08X}", find_object_id)
	LV_Row := GetLVRowByResult(result)
	LV_Row1 := GetLVRowByOID(find_object_id)
	findMID := mem.read(result + 0x70, "Int", aOffsets*)
	gui, listview, %ListGUI%
	LV_GetText(분류,LV_Row,1)
	kind := "아이템"
	if (addr != AddressToCheck)
    {
        ItemList.RemoveAt(index)
		if (LV_Row > 0)
		{
			gui, listview, %ListGUI%
			LV_Delete(LV_Row)
			continue
		}
		else if (LV_Row1 > 0)
		{
			gui, listview, %ListGUI%
			LV_Delete(LV_Row1)
			continue
		}
	}
    find_x := mem.read(result + 0x0C, "UInt", aOffsets*)
	find_y := mem.read(result + 0x10, "UInt", aOffsets*)
	find_z := mem.read(result + 0x14, "UInt", aOffsets*)
	find_name := mem.readString(mem.read(result + 0x62, "UInt", aOffsets*), 20, "UTF-16",aOffsets*)
	distanceXYZ := Abs(find_x - 좌표X) + Abs(find_y - 좌표Y) + Abs(find_z - 좌표Z) * 20

	if (LV_Row > 0)
	{
		gui, listview, %ListGUI%
		LV_Modify(LV_Row,"", kind, 차원, 맵이름, 맵번호, find_name, find_object_id, find_x, find_y, find_z, resultHex, 2, distanceXYZ ,findMID)
		continue
	}
	else if (LV_Row1 > 0)
	{
		gui, listview, %ListGUI%
		LV_Modify(LV_Row1,"", kind, 차원, 맵이름, 맵번호, find_name, find_object_id, find_x, find_y, find_z, resultHex, 2, distanceXYZ ,findMID)
		continue
	}
	find_name := mem.readString(mem.read(result + 0x62, "UInt", aOffsets*), 20, "UTF-16",aOffsets*)
	gui, listview, %ListGUI%
	LV_Add("", kind, 차원, 맵이름, 맵번호, find_name, find_object_id, find_x, find_y, find_z, resultHex, 2, distanceXYZ ,findMID)
}
Gui, listview, 아이템리스트
i := 1
loop % LV_GetCount()
{
	LV_GetText(삭제딜레이,i,11)
	LV_GetText(아이템이름,i,5)
	LV_GetText(아이템위치X,i,7)
	LV_GetText(아이템위치Y,i,8)
	LV_GetText(아이템위치Z,i,9)
	LV_GetText(아이템주소,i,10)
	좌표X := mem.read(0x0058DAD4, "UInt", 0x10)
	좌표Y := mem.read(0x0058DAD4, "UInt", 0x14)
	거리X := ABS(좌표X-아이템위치X)
	거리Y := ABS(좌표Y-아이템위치Y)
	거리 := 거리X + 거리Y
	addr := mem.read(아이템주소, "UInt", aOffsets*)
	find_name := mem.readString(mem.read(아이템주소 + 0x62, "UInt", aOffsets*), 20, "UTF-16",aOffsets*)
	if ((addr != AddressToCheck) || ( find_name != 아이템이름))
    {
		LV_Delete(i)
		continue
	}
	LV_Modify(i,"Col12",거리)
	i++
}


return
;}

아이템_선택:
;{
gui, listview, 아이템리스트
LVCount := LV_GetCount()
LVSelect := LV_GetNext(0)
if ((LVSelect != 0) || (LVCount = 0))
{
	if (!IsDataInList(col5Value, WantedItems) && WantedItemlength >= 1)
	{
		gui, listview, 아이템리스트
		LV_Modify(0,"-Select")
	}
}
lowestCol12Value := 999999 ; 초기 높은 값으로 설정
selectedRow := 0 ; 선택할 행 초기화
/*
	WantedItems
	WantedMonsters
	BlackList
	WantedItemlength := WantedItems.MaxIndex()
	WantedMonsterlength := WantedMonsters.MaxIndex()
	BlackListlength := BlackList.MaxIndex()
blackList := ["값1", "값2", "값3"] ; 블랙리스트 값들의 배열
wantedList := ["원하는값1", "원하는값2", "원하는값3"] ; 원하는 값들의 배열
*/

; ListView의 모든 행을 검색합니다
 ; ListView의 항목 수를 가져옵니다
WantedItemlength := 0 ; 기본값을 0으로 설정
if WantedItems.MaxIndex() ; 배열이 비어있지 않은 경우
    WantedItemlength := WantedItems.MaxIndex()

Loop, %LVCount%
{
    thisRow := A_Index
    LV_GetText(col12Value, thisRow, 12) ; 현재 행의 Col12 값을 가져옵니다
	LV_GetText(col11Value, thisRow, 11) ; 현재 행의 Col12 값을 가져옵니다
    LV_GetText(col5Value, thisRow, 5) ; 현재 행의 Col5 값을 가져옵니다
    LV_GetText(col6Value, thisRow, 6) ; 현재 행의 Col6 값을 가져옵니다
	;SB_SetText("비교중" A_Index " " WantedMonsterlength, 5)

    ; Col12 값이 현재 가장 낮은 값보다 낮고, Col5 값이 WantedList에 포함되고, Col6 값이 BlackList에 없는 경우
    if (col11Value < 3 && col12Value < lowestCol12Value && !IsDataInList(col6Value, BlackList)) && (IsDataInList(col5Value, WantedItems) || WantedItemlength < 1)
    {
        lowestCol12Value := col12Value
        selectedRow := thisRow
    }
}

; 가장 낮은 Col12 값을 가지고 WantedList에 포함되며 BlackList에 없는 행을 선택합니다
if (selectedRow > 0)
{
    LV_Modify(selectedRow, "Select") ; 해당 행을 선택합니다
}

return
;}

메모리검색_아이템_광산:
;{
; Constants
AddressToCheck := 0x0053ECA4
ListGUI := "아이템리스트"

ItemList := []

; Initialize ListView
gui, listview, %ListGUI%
; Read memory and populate ItemList
startAddress := 0x005908A4
endAddress := 0x00590900
while (startAddress <= endAddress)
{
    data := mem.read(startAddress, "UInt", aOffsets*)
    if (!IsDataInList(data, ItemList))
        ItemList.Push(data)
    startAddress += 4
}

좌표X := mem.read(0x0058DAD4, "UInt", 0x10)
좌표Y := mem.read(0x0058DAD4, "UInt", 0x14)
좌표Z := mem.read(0x0058DAD4, "UInt", 0x18)
for index, result in ItemList
{
    resultHex := Format("0x{:08X}", result)
    addr := mem.read(resultHex, "UInt", aOffsets*)
	if (addr != AddressToCheck)
    {
        ItemList.RemoveAt(index)
		continue
	}
	find_object_id := mem.read(result + 0x5E, "UInt",aOffsets*)
	find_object_id := Format("0x{:08X}", find_object_id)
	LV_Row := GetLVRowByOID(find_object_id)
	find_name := mem.readString(mem.read(result + 0x62, "UInt", aOffsets*), 20, "UTF-16",aOffsets*)
	findMID := mem.read(result + 0x70, "Int", aOffsets*)
	gui, listview, %ListGUI%
	LV_GetText(분류,LV_Row,1)
	kind := "아이템"

    find_x := mem.read(result + 0x0C, "UInt", aOffsets*)
	find_y := mem.read(result + 0x10, "UInt", aOffsets*)
	find_z := mem.read(result + 0x14, "UInt", aOffsets*)
	distanceXYZ := Abs(find_x - 좌표X) + Abs(find_y - 좌표Y)
	if (LV_Row > 0)
	{
		LV_Modify(LV_Row, "", kind, 차원, 맵이름, 맵번호, find_name, find_object_id, find_x, find_y, find_z, resultHex, 2, distanceXYZ ,findMID)
		continue
	}

	Lucky := True
	if (find_z = 0)
	{
		gui, listview, 플레이어리스트
		loop % LV_GetCount()
		{
			LV_GetText(기존_x, A_Index, 7)
			LV_GetText(기존_y, A_Index, 8)
			if(find_x = 기존_x && find_y = 기존_y)
			{
				BlackList.push(find_object_id)
				Lucky := False
				break
			}
		}
		gui, listview, 몬스터리스트
		loop % LV_GetCount()
		{
			LV_GetText(기존_x, A_Index, 7)
			LV_GetText(기존_y, A_Index, 8)
			if(find_x = 기존_x && find_y = 기존_y)
			{
				BlackList.push(find_object_id)
				Lucky := False
				break
			}
		}
	}
	else
	{
		continue
	}
	if !Lucky
	{
		continue
	}
	gui, listview, %ListGUI%
	LV_Add("", kind, 차원, 맵이름, 맵번호, find_name, find_object_id, find_x, find_y, find_z, resultHex, 2, distanceXYZ ,findMID)

}

Gui, listview, 아이템리스트
i := 1
loop % LV_GetCount()
{
	LV_GetText(삭제딜레이,i,11)
	LV_GetText(아이템이름,i,5)
	LV_GetText(아이템위치X,i,7)
	LV_GetText(아이템위치Y,i,8)
	LV_GetText(아이템위치Z,i,9)
	LV_GetText(아이템주소,i,10)
	좌표X := mem.read(0x0058DAD4, "UInt", 0x10)
	좌표Y := mem.read(0x0058DAD4, "UInt", 0x14)
	거리X := ABS(좌표X-아이템위치X)
	거리Y := ABS(좌표Y-아이템위치Y)
	거리 := 거리X + 거리Y
	find_name := mem.readString(mem.read(아이템주소 + 0x62, "UInt", aOffsets*), 20, "UTF-16",aOffsets*)
	LV_Modify(i,"Col12",거리)
	삭제딜레이 -= 1
	if (거리X>=16 && 거리Y>=8)
	{
		LV_Modify(i,"Col11",2)
		LV_Modify(i,"Col11",삭제딜레이)
	}
	else if (거리X<16 && 거리Y<8 ) || (아이템위치Z = 1)
	{
		AddressResult := mem.read(아이템주소, "UInt", aOffsets*)
		find_z := mem.read(아이템주소 + 0x14, "UInt", aOffsets*)
		if (AddressResult != AddressToCheck || find_z = 1 || 아이템위치Z = 1 || find_name != 아이템이름)
		{
			LV_Delete(i)
			keyclick("ALtR")
			sleep,1
			continue
		}
	}
	i++
}

return
;}

소각하기:
;{
guicontrolget, 소각활성화
gui, listview, 소각할아이템대기리스트
if (소각활성화 = 1 && LV_GetCount() > 0 )
{
	LV_GetText(아이템,1,1)
	if (아이템 != "" )
	{
		소각할아이템바꾸기 := mem.writeString(0x00590147, 아이템, "UTF-16", aOffsets*) ;소각할 아이템
		RunMemory("하나씩소각")
		gui, listview, 소각할아이템대기리스트
		LV_Delete(1)
	}
}
return
;}

은행보관:
;{
guicontrolget, 은행넣기활성화
gui, listview, 은행넣을아이템대기리스트
if (은행넣기활성화 = 1 && LV_GetCount() > 0)
{
	LV_GetText(아이템,1,1)
	if (아이템 != "" )
	{
		은행넣을아이템바꾸기 := mem.writeString(0x00590500, 아이템, "UTF-16", aOffsets*) ;은행에 넣을 아이템
		RunMemory("은행넣기")
		gui, listview, 은행넣을아이템대기리스트
		LV_Delete(1)
	}
}
return
;}

;}

접속여부확인: ; 2번 스레드
;{
접속여부확인상태RunCount++
guicontrol, ,접속여부확인상태, 접속여부확인횟수: %접속여부확인상태RunCount%

gui, submit, nohide
PT_Delay := A_TickCount - PT_Delays
if (자동파티여부 = 1 && PT_Delay > 60000)
{
	gosub, 원격파티하기
	PT_Delays := A_TickCount
}

if (자동재접속사용여부 = 1 && TargetTitle != "")
{
	Server := mem.read(0x0058DAD0, "UChar", 0xC, 0x8, 0x8, 0x6C)
	ServerConnectionCheck := mem.readString(0x0017E574, 40, "UTF-16", aOffsets*)

	if (최대HP = "" || 최대HP = 0) && (최대MP = "" || 최대MP = 0)  && (최대FP = "" || 최대FP = 0)
	{
		sb_settext("비정상",4)
		STOPSIGN := true
		서버상태 := False
		sleep,2000
	}
	sleep, 100
	IfInString,ServerConnectionCheck,서버와의 연결이
	{
		sleep, 100
		mem.writeString(0x0017E574, "", "UTF-16", aOffsets*)
		ControlSend, , {Enter}, ahk_pid %targetPid%
		sb_settext("비정상",4)
		서버상태 := False
		sleep,2000
		MouseClick(467,309)
	}
	sleep, 100
	WINGETTEXT, WindowErrorMsg, ahk_class #32770
	IfInString,WindowErrorMsg,프로그램을 닫으십시오
	{
		CONTROLCLICK, Button1, ahk_class #32770
		sb_settext("비정상",4)
		서버상태 := False
		sleep,500
		return
	}
	sleep, 100
	IfWinExist,Microsoft Windows
	{
		WinClose
		sb_settext("비정상",4)
		서버상태 := False
		sleep,2000
		return
	}
	sleep, 100
	IfWinExist,Microsoft Visual C++ Runtime Library
	{
		WinClose
		sb_settext("비정상",4)
		서버상태 := False
		sleep,2000
		return
	}
	sleep, 100
	IfWinExist,ahk_exe WerFault.exe
	{
		CONTROLCLICK, Button2, ahk_exe WerFault.exe
		PROCESS, Close, WerFault.exe
		sb_settext("비정상",4)
		서버상태 := False
		sleep,2000
		return
	}
	sleep, 100
	IfWinExist, ahk_pid %TargetPid%
	{
		if DllCall("IsHungAppWindow", "UInt", WinExist())
		{
			PROCESS, Close, %jPID%
			sb_settext("비정상",4)
			서버상태 := False
			sleep,2000
			return
		}
	}
	sleep, 100
	WINGETTEXT, WindowErrorMsg, ahk_class #32770
	IfInString,WindowErrorMsg,프로그램을 마치려면
	{
		CONTROLCLICK, Button1, ahk_class #32770
		sb_settext("비정상",4)
		서버상태 := False
		sleep,500
		return
	}
	sleep, 100
	IfInString,WindowErrorMsg,작동이 중지되었습니다.
	{
		CONTROLCLICK, Button1, ahk_class #32770
		sb_settext("비정상",4)
		서버상태 := False
		sleep,500
		return
	}
	sleep, 100
	IfWinNotExist,ahk_pid %TargetPid%
	{
		sb_settext("비정상",4)
		서버상태 := False
		sleep,500
		return
	}
}
return
;}

나프마통작:
;{
gui, submit, nohide
if (나프사용 = 1)
{
	마법사용("나프", "자신")
	sleep, 1
}
if (클리드사용 = 1)
{
	마법사용("클리드", "자신")
	sleep, 1
}
if (브렐사용 = 1)
{
	마법사용("브렐", "자신")
	sleep, 1
}
if (리메듐사용 = 1)
{
	마법사용("리메듐", 특수리메듐타겟OID)
	sleep, 1
}
if (라리메듐사용 = 1)
{
	마법사용("라리메듐", 특수리메듐타겟OID)
	sleep, 1
}
if (엘리메듐사용 = 1)
{
	마법사용("엘리메듐", 특수리메듐타겟OID)
	sleep, 1
}
if (마스사용 = 1)
{
	마법사용("마스", 특수원거리타겟OID)
	sleep, 1
}
상승어빌 := mem.readString(상승어빌주소 + 0x64, 20, "UTF-16", aOffsets*)
if (IsWordInList(상승어빌, 마통작마법))
{
	상승어빌값 := mem.read(상승어빌주소 + 0x264, "UInt", aOffsets*)
	상승어빌카운트 := mem.read(상승어빌주소 + 0x264 + 0x8, "UShort", aOffsets*)
	필요어빌카운트 := mem.read(상승어빌주소 + 0x264 + 0xA, "UShort", aOffsets*)
	raisedCount := UpdateAbility(상승어빌, 상승어빌값, 상승어빌카운트, 필요어빌카운트)
	if (raisedCount > 0)
	{
		; 가장 최근에 오른 4가지 어빌 중에서 업데이트
		found := false
		for index, ability in abilities {
			if (ability.Name = 상승어빌) {
				UpdateGUI(index, raisedCount)
				found := true
				break
			}
		}
		if (!found) {
			; 비어있는 어빌 슬롯 찾기 및 업데이트
			for index, ability in abilities {
				if (ability.Name = "") {
					abilities[index].Name := 상승어빌
					UpdateGUI(index, raisedCount)
					break
				}
			}
		}
	}
}

return
;}

스킬사용하기: ; 3번 스레드
;{
	if !(서버상태) || (거래창사용중) || !(Coin)
	{
		return
	}
	스킬마법재사용딜레이 := 10
	gui,submit,nohide
	스킬사용상태RunCount++
	guicontrol, ,스킬사용상태, %스킬사용상태RunCount%

	현재무기 := mem.read(0x0058DAD4, "UInt", 0x121)
	if (일무기 == 1 && 현재무기 == 0)
	{
		keyclick(1)
	}
	;단축키사용
	;{
	if !(NPC대화창사용중) && !(거래창사용중)
	{
		if (3번 = 1)
		{
			keyclick("k3")
			sleep,1
		}
		if (4번 = 1)
		{
			keyclick("k4")
			sleep,1
		}
		if (5번 = 1)
		{
			keyclick("k5")
			sleep,1
		}
		if (6번 = 1)
		{
			keyclick("k6")
			sleep,1
		}
		if (7번 = 1)
		{
			keyclick("k7")
			sleep,1
		}
		if (8번 = 1)
		{
			keyclick("k8")
			sleep,1
		}
	}
	;}

	;기본스킬
	;{
		for Index, skill in CommonSkillList
		{
			temp_skill_usecheck := %skill%사용
			if (temp_skill_usecheck == 1)
			{
				스킬사용(skill)
				sleep, %스킬마법재사용딜레이%
			}

		}
	;}

	;기본마법 쓰고,
	;{
	/*
		for Index, spell in SpellList
			{
				temp_skill_usecheck := %spell%사용
				CurrentWeapon := mem.read(0x0058DAD4, "UInt", 0x121)
				if !(CurrentWeapon = 0 || CurrentWeapon = 49153)
					continue
				if (temp_skill_usecheck == 1 && CurrentWeapon = 0) && (spell = "리메듐" || spell = "라리메듐" || spell = "엘리메듐" || spell = "클리드" || spell = "브렐" || spell = "브레마" || spell = "쿠로" )
				{
					if (리메듐타겟 = 1)
						마법사용(spell, 특수리메듐타겟OID)
					else
						마법사용(spell, "자신")
					sleep, %스킬마법재사용딜레이%
				}
			}

	;}
	*/

	;딜레이 긴 기본스킬 쓰고
	;{
		SK_Delay := A_TickCount - NSK_Counts
		if (SK_Delay > 3000 )
		{
			NSK_Counts := A_TickCount
			for Index, skill in NormalSkillList
			{
				temp_skill_usecheck := %skill%사용
				if (temp_skill_usecheck == 1)
				{
					스킬사용(skill)
					sleep, %스킬마법재사용딜레이%
				}
			}
		}
	;}

	;만약 자사중이면 몬스터 치는지 확인해서 타겟스킬 쓰고
	;{
		gui,listview,몬스터리스트
		원거리대상갯수 := LV_GetCount()
		;원거리선택중대상 := LV_GetNext(0)
		if (원거리대상갯수 > 0 )||(CurrentMode = "마잠또는밥통") ;&& 원거리선택중대상 != 0)
		{
			원거리루프++
			if (원거리루프 >= 원거리대상갯수)
			{
				원거리루프 := 1
			}

			CurrentWeapon := mem.read(0x0058DAD4, "UInt", 0x121)
			if (CurrentWeapon = 0 || CurrentWeapon = 49153) ; "주먹", "하프", "스태프" 번호 기록 필요
			{
				if (원거리타겟 = 0)
				{
					lv_gettext(특수원거리타겟OID,원거리루프,6)
					guicontrol,,특수원거리타겟OID,%특수원거리타겟OID%
				}
				for Index, spell in SpellList
				{
					;gui,listview,몬스터리스트
					;원거리선택중대상 := LV_GetNext(0)
					;if (원거리선택중대상 = 0)
					;{
					;	break
					;}
					temp_skill_usecheck := %spell%사용
					CurrentWeapon := mem.read(0x0058DAD4, "UInt", 0x121)
					if (temp_skill_usecheck == 1) && (spell = "리메듐" || spell = "라리메듐" || spell = "엘리메듐" || spell = "나프")
					{
						if (리메듐타겟 = 1)
							마법사용(spell, 특수리메듐타겟OID)
						else
							마법사용(spell, "자신")
						sleep, %스킬마법재사용딜레이%
					}
					else if ((temp_skill_usecheck == 1 && 특수원거리타겟OID != 0x0 && 특수원거리타겟OID != "") && (원거리타겟 || 원거리대상갯수 != 0))
					{
						마법사용(spell, 특수원거리타겟OID)
						sleep, %스킬마법재사용딜레이%
					}
					else if (temp_skill_usecheck == 1) && (spell = "클리드" || spell = "브렐" || spell = "브레마")
					{
						마법사용(spell, "자신")
						sleep, %스킬마법재사용딜레이%
					}
				}
			}
			for Index, spell in TargetSkillList
			{
				gui,listview,몬스터리스트
				;원거리선택중대상 := LV_GetNext(0)
				;if (원거리선택중대상 = 0)
				;{
				;	break
				;}
				temp_skill_usecheck := %spell%사용
				gui,listview,몬스터리스트
				몬스터리스트선택 := LV_GetNext(0)
				if (temp_skill_usecheck == 1 && 원거리대상갯수 != 0) && (spell = "무기공격" )
				{
					타겟스킬사용(spell, "클릭된대상")
					sleep, %스킬마법재사용딜레이%
				}
				else if (temp_skill_usecheck == 1 && 원거리대상갯수 != 0) && (특수원거리타겟OID != 0x0 || 특수원거리타겟OID != "")
				{
					타겟스킬사용(spell, 특수원거리타겟OID)
					sleep, %스킬마법재사용딜레이%
				}
			}
		}
		;}

return
;}

OpenLink:
    Run, https://github.com/SuperPowerJ/H-Elancia
return