-- InsertEvolutionRecipeLGU( 펫알ITID, 진화후펫알ITID, 재료ITID, 재료Cnt );


function main()

	--------------------------------------------------------------------------------------

	-- 포링알(9001) 진화테이블

	-- 1. 포링알(9001)->마스터링알(9069)로 진화
	InsertEvolutionRecipeLGU( 9001, 9069, 610, 10 );	-- 마스터링알 : 이그드라실잎(610) 10개
	InsertEvolutionRecipeLGU( 9001, 9069, 619, 3 );	-- 마스터링알 : 덜익은사과(619) 3개

	InsertPetAutoFeeding( 9069 );	-- 마스터링알 자동 먹이 주기 추가

	-- 2. 세비지베베알(9009)->세비지알(9070)로 진화
	InsertEvolutionRecipeLGU( 9009, 9070, 537, 10 );	-- 세비지알 : 펫푸드(537) 10개
	InsertEvolutionRecipeLGU( 9009, 9070, 627, 3 );	-- 세비지알 : 달콤한 우유(627) 3개
	InsertEvolutionRecipeLGU( 9009, 9070, 517, 100 );	-- 세비지알 : 고기(517) 100개
	InsertEvolutionRecipeLGU( 9009, 9070, 949, 50 );	-- 세비지알 : 부드러운털(949) 50개
	
	InsertPetAutoFeeding( 9070 );	-- 세비지알 자동 먹이 주기 추가

	-- 3. 페코페코알(9014)->그랜드페코페코알(9071)로 진화
	InsertEvolutionRecipeLGU( 9014, 9071, 537, 10 );	-- 그랜드페코페코알 : 펫푸드(537) 10개
	InsertEvolutionRecipeLGU( 9014, 9071, 632, 3 );	-- 그랜드페코페코알 : 토실토실 지렁이(632) 3개
	InsertEvolutionRecipeLGU( 9014, 9071, 7101, 300 );	-- 그랜드페코페코알 : 페코날개깃털(7101) 300개
	InsertEvolutionRecipeLGU( 9014, 9071, 4031, 1 );	-- 그랜드페코페코알 : 페코페코카드(4031) 1개
	InsertEvolutionRecipeLGU( 9014, 9071, 522, 10 );	-- 그랜드페코페코알 : 마스테라의열매(522) 10개
	
	InsertPetAutoFeeding( 9071 );	-- 그랜드페코페코알 자동 먹이 주기 추가

	-- 4. 오크워리어알(9017)->하이오크알(9087)로 진화
	InsertEvolutionRecipeLGU( 9017, 9087, 635, 3 );	-- 하이오크알 : 조직의쓴맛(635) 3개
	InsertEvolutionRecipeLGU( 9017, 9087, 1124, 1 );	-- 하이오크알 : 오키쉬소드(1124) 1개
	InsertEvolutionRecipeLGU( 9017, 9087, 931, 500 );	-- 하이오크알 : 오크전사의증표(931) 500개
	InsertEvolutionRecipeLGU( 9017, 9087, 2267, 1 );	-- 하이오크알 : 담배(2267) 1개
	InsertEvolutionRecipeLGU( 9017, 9087, 4066, 1 );	-- 하이오크알 : 오크워리어카드(4066) 1개
	
	InsertPetAutoFeeding( 9087 );	-- 하이오크알 자동 먹이 주기 추가

	-- 신규 진화펫 5종

	-- 6. 이시스알(9021)->리틀이시스알(9090)로 진화
	InsertEvolutionRecipeLGU( 9021, 9090, 639, 3 );	-- 리틀이시스알 : 복종의팔찌(639) 3개
	InsertEvolutionRecipeLGU( 9021, 9090, 10006, 1 );	-- 리틀이시스알 : 여왕의머리장식(10006) 1개
	InsertEvolutionRecipeLGU( 9021, 9090, 954, 300 );	-- 리틀이시스알 : 빛나는비늘(954) 300개
	InsertEvolutionRecipeLGU( 9021, 9090, 732, 6 );	-- 리틀이시스알 : 투명한보석__(732) 6개

	InsertPetAutoFeeding( 9090 );	-- 리틀이시스알 자동 먹이 주기 추가

	-- 7. 마스터링알(9069)->엔젤링알(9088)로 진화
	InsertEvolutionRecipeLGU( 9069, 9088, 503, 20 );	-- 엔젤링알 : 노란포션(503) 20개
	InsertEvolutionRecipeLGU( 9069, 9088, 2282, 1 );	-- 엔젤링알 : 영혼고리(2282) 1개
	InsertEvolutionRecipeLGU( 9069, 9088, 509, 50 );	-- 엔젤링알 : 하얀허브(509) 50개
	InsertEvolutionRecipeLGU( 9069, 9088, 909, 200 );	-- 엔젤링알 : 젤로피(909) 200개

	InsertPetAutoFeeding( 9088 );	-- 엔젤링알 자동 먹이 주기 추가

	-- 8. 드롭프스알(9002)->에그링알(9092)로 진화
	InsertEvolutionRecipeLGU( 9002, 9092, 7032, 20 );	-- 에그링알 : 달걀껍질조각(7032) 20개
	InsertEvolutionRecipeLGU( 9002, 9092, 7031, 10 );	-- 에그링알 : 헌후라이펜(7031) 10개
	InsertEvolutionRecipeLGU( 9002, 9092, 531, 3 );	-- 에그링알 : 사과쥬스(531) 3개
	InsertEvolutionRecipeLGU( 9002, 9092, 4659, 1 );	-- 에그링알 : 에그링카드(4659) 1개

	InsertPetAutoFeeding( 9092 );	-- 에그링알 자동 먹이 주기 추가

	-- 9. 요요알(9016)->쵸코알(9091)로 진화
	InsertEvolutionRecipeLGU( 9016, 9091, 634, 3 );	-- 쵸코알 : 열대의바나나(634) 3개
	InsertEvolutionRecipeLGU( 9016, 9091, 753, 2 );	-- 쵸코알 : 원숭이인형(753) 2개
	InsertEvolutionRecipeLGU( 9016, 9091, 7182, 300 );	-- 쵸코알 : 카카오(7182) 300개
	InsertEvolutionRecipeLGU( 9016, 9091, 4051, 1 );	-- 쵸코알 : 요요카드(4051) 1개

	InsertPetAutoFeeding( 9091 );	-- 쵸코알 자동 먹이 주기 추가

	-- 10. 도깨비알(9019)->암무트알(9089)로 진화
	InsertEvolutionRecipeLGU( 9019, 9089, 637, 3 );	-- 암무트알 : 헌빗자루(637) 3개
	InsertEvolutionRecipeLGU( 9019, 9089, 981, 3 );	-- 암무트알 : 보라색염료(981) 3개
	InsertEvolutionRecipeLGU( 9019, 9089, 1021, 300 );	-- 암무트알 : 도깨비의뿔(1021) 300개
	InsertEvolutionRecipeLGU( 9019, 9089, 969, 3 );	-- 암무트알 : 황금(969) 3개

	InsertPetAutoFeeding( 9089 );	-- 암무트알 자동 먹이 주기 추가

	-- 신규 진화펫 5종

	-- 11. 본건알(9025)->혜군알(9093)로 진화
	InsertEvolutionRecipeLGU( 9025, 9093, 5367, 1 );	-- 혜군알 : 혜군모자(5367) 1개
	InsertEvolutionRecipeLGU( 9025, 9093, 7277, 100 );	-- 혜군알 : 무낙인형(7277) 100개
	InsertEvolutionRecipeLGU( 9025, 9093, 7014, 50 );	-- 혜군알 : 낡은자화상(7014) 50개
	InsertEvolutionRecipeLGU( 9025, 9093, 4328, 1 );	-- 혜군알 : 혜군카드(4328) 1개

	InsertPetAutoFeeding( 9093 );	-- 혜군알 자동 먹이 주기 추가

	-- 12. 쁘띠알(9022)->빨간딜리터알2(9098)로 진화
	InsertEvolutionRecipeLGU( 9022, 9098, 640, 3 );	-- 빨간딜리터알2 : 반짝이는돌(640) 3개
	InsertEvolutionRecipeLGU( 9022, 9098, 6260, 100 );	-- 빨간딜리터알2 : 쁘띠의꼬리(6260) 100개
	InsertEvolutionRecipeLGU( 9022, 9098, 606, 150 );	-- 빨간딜리터알2 : 알로에베라(606) 150개
	InsertEvolutionRecipeLGU( 9022, 9098, 4279, 1 );	-- 빨간딜리터알2 :지상딜리터카드(4279) 1개

	InsertPetAutoFeeding( 9098 );	-- 빨간딜리터알2 자동 먹이 주기 추가

	-- 13. 데비루치알(9023)->디아볼릭알2(9097)로 진화
	InsertEvolutionRecipeLGU( 9023, 9097, 641, 3 );	-- 디아볼릭알2 : 어둠의계약서(641) 3개
	InsertEvolutionRecipeLGU( 9023, 9097, 1039, 250 );	-- 디아볼릭알2 : 새끼악마의날개(1039) 250개
	InsertEvolutionRecipeLGU( 9023, 9097, 1009, 30 );	-- 디아볼릭알2 : 성흔(1009) 30개
	InsertEvolutionRecipeLGU( 9023, 9097, 4122, 1 );	-- 디아볼릭알2 : 데비루치카드(4122) 1개

	InsertPetAutoFeeding( 9097 );	-- 디아볼릭알2 자동 먹이 주기 추가

	-- 14. 구미호알(9095)->캣오나인테일알(9096)로 진화
	InsertEvolutionRecipeLGU( 9095, 9096, 23187, 3 );	-- 캣오나인테일알 : 수액젤리(23187) 3개
	InsertEvolutionRecipeLGU( 9095, 9096, 1022, 999 );	-- 캣오나인테일알 : 여우의꼬리(1022) 999개
	InsertEvolutionRecipeLGU( 9095, 9096, 10008, 1 );	-- 캣오나인테일알 : 정신봉(10008) 1개
	InsertEvolutionRecipeLGU( 9095, 9096, 4159, 1 );	-- 캣오나인테일알 : 구미호카드(4159) 1개

	InsertPetAutoFeeding( 9096 );	-- 캣오나인테일알 자동 먹이 주기 추가

	-- 15. 루나틱알(9004)->리프루나틱알(9094)로 진화
	InsertEvolutionRecipeLGU( 9004, 9094, 7198, 100 );	-- 리프루나틱알 : 커다란잎사귀(7198) 100개
	InsertEvolutionRecipeLGU( 9004, 9094, 705, 250 );	-- 리프루나틱알 : 클로버(705) 250개
	InsertEvolutionRecipeLGU( 9004, 9094, 706, 30 );	-- 리프루나틱알 : 네잎클로버(706) 30개
	InsertEvolutionRecipeLGU( 9004, 9094, 4663, 1 );	-- 리프루나틱알 : 리프루나틱카드(4663) 1개

	InsertPetAutoFeeding( 9094 );	-- 리프루나틱알 자동 먹이 주기 추가

	-- 16. 그렘린알(9100)->호드렘린알(9105)로 진화
	InsertEvolutionRecipeLGU( 9100, 9105, 23188, 3 );	-- 호드렘린알 : 비공정부품(23188) 3개
	InsertEvolutionRecipeLGU( 9100, 9105, 6100, 50 );	-- 호드렘린알 : 음습한어둠(6100) 50개
	InsertEvolutionRecipeLGU( 9100, 9105, 7340, 200 );	-- 호드렘린알 : 암흑의의지(7340) 200개
	InsertEvolutionRecipeLGU( 9100, 9105, 4413, 1 );	-- 호드렘린알 : 호드렘린카드(4413) 1개

	InsertPetAutoFeeding( 9105 );	-- 호드렘린알 자동 먹이 주기 추가

	-- 17. 로커알(9011)->메틀러알(9106)로 진화
	InsertEvolutionRecipeLGU( 9011, 9106, 707, 3 );	-- 메틀러알 : 노래하는풀(707) 3개
	InsertEvolutionRecipeLGU( 9011, 9106, 940, 777 );	-- 메틀러알 : 메뚜기뒷다리(940) 777개
	InsertEvolutionRecipeLGU( 9011, 9106, 508, 200 );	-- 메틀러알 : 노란허브(508) 200개
	InsertEvolutionRecipeLGU( 9011, 9106, 4057, 1 );	-- 메틀러알 : 메틀러카드(4057) 1개

	InsertPetAutoFeeding( 9106 );	-- 메틀러알 자동 먹이 주기 추가

	-- 18. 미이라알(9102)->에인션트미이라알(9107)로 진화
	InsertEvolutionRecipeLGU( 9102, 9107, 23256, 3 );	-- 에인션트미이라알 : 영험한붕대(23256) 3개
	InsertEvolutionRecipeLGU( 9102, 9107, 7511, 200 );	-- 에인션트미이라알 : 어둠의룬(7511) 200개
	InsertEvolutionRecipeLGU( 9102, 9107, 969, 30 );	-- 에인션트미이라알 : 황금(969) 30개
	InsertEvolutionRecipeLGU( 9102, 9107, 4248, 1 );	-- 에인션트미이라알 : 에인션트미이라카드(4248) 1개

	InsertPetAutoFeeding( 9107 );	-- 에인션트미이라알 자동 먹이 주기 추가

	-- 19. 곰인형알(9099)->버려진곰인형알(9108)로 진화
	InsertEvolutionRecipeLGU( 9099, 9108, 23189, 3 );	-- 버려진곰인형알 : 작은인형바늘(23189) 3개
	InsertEvolutionRecipeLGU( 9099, 9108, 7442, 300 );	-- 버려진곰인형알 : 저주받은인(7442) 300개
	InsertEvolutionRecipeLGU( 9099, 9108, 724, 50 );	-- 버려진곰인형알 : 진홍색보석_(724) 50개
	InsertEvolutionRecipeLGU( 9099, 9108, 4340, 1 );	-- 버려진곰인형알 : 곰인형카드(4340) 1개

	InsertPetAutoFeeding( 9108 );	-- 버려진곰인형알 자동 먹이 주기 추가

	-- 23. 요선녀알(9047)->백소진알(9115)로 진화
	InsertEvolutionRecipeLGU( 9047, 9115, 25375, 30 );	-- 백소진알 : 강력한영혼의정수(25375) 30개
	InsertEvolutionRecipeLGU( 9047, 9115, 4202, 10 );	-- 백소진알 : 묘괴카드(4202) 10개
	InsertEvolutionRecipeLGU( 9047, 9115, 4265, 10 );	-- 백소진알 : 이매망량카드(4265) 10개
	InsertEvolutionRecipeLGU( 9047, 9115, 4272, 10 );	-- 백소진알 : 저파룡카드(4272) 10개

	InsertPetAutoFeeding( 9115 );	-- 백소진알 자동 먹이 주기 추가

	-- 21. 캣오나인테일알(9096)->월야화알(9112)로 진화
	InsertEvolutionRecipeLGU( 9096, 9112, 25375, 30 );	-- 월야화알 : 강력한영혼의정수(25375) 30개
	InsertEvolutionRecipeLGU( 9096, 9112, 4159, 10 );	-- 월야화알 : 구미호카드(4159) 10개
	InsertEvolutionRecipeLGU( 9096, 9112, 4100, 10 );	-- 월야화알 : 소희카드(4100) 10개
	InsertEvolutionRecipeLGU( 9096, 9112, 4090, 10 );	-- 월야화알 : 무낙카드(4090) 10개

	InsertPetAutoFeeding( 9112 );	-- 월야화알 자동 먹이 주기 추가

	InsertPetAutoFeeding( 9111 );	-- 프리오니알 자동 먹이 주기 추가


	--------------------------------------------------------------------------------------	

	return true, "success"
end



