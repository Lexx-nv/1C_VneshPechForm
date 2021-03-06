
Процедура ПолучитьРуководителяПредприятия(итТбл)
	Организация = СсылкаНаОбъект.Организация;
	Дата = СсылкаНаОбъект.Дата;
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	               |	ОтвРук.ФизическоеЛицо  КАК ФизЛицо
				   |INTO врФЛ
	               |ИЗ
	               |	РегистрСведений.ОтветственныеЛицаОрганизации.СрезПоследних(&ДатаСреза,ОтветственноеЛицо = Значение(Перечисление.ОтветственныеЛицаОрганизации.Руководитель)) КАК ОтвРук
				   |WHERE ОтвРук.СтруктурнаяЕдиница = &Организация
				   | ;
				   |
				   |SELECT
				   | ФизЛица.ФизЛицо.Наименование ФЛимя,
				   | Должность.Наименование ДЛж,
				   | РегФИО.Фамилия,
				   | РегФИО.Имя,
				   | РегФИО.Отчество
				   |
				   |
				   |FROM врФЛ ФизЛица
				   |
				   |ЛЕВОЕ СОЕДИНЕНИЕ 
				   |		(ВЫБРАТЬ 
				   |			РаботникиОрганизацийСрезПоследних.ТабельныйНомер КАК ТабельныйНомер,
				   |			РаботникиОрганизацийСрезПоследних.Период,
				   |			РаботникиОрганизацийСрезПоследних.Сотрудник КАК Сотрудник,
				   |			РаботникиОрганизацийСрезПоследних.Должность КАК Должность,
				   |			РаботникиОрганизацийСрезПоследних.ПодразделениеОрганизации КАК ПодразделениеОрганизации
				   |		ИЗ
				   |			РегистрСведений.уатСведенияОСотрудниках.СрезПоследних(&ДатаСреза, Сотрудник.ФизЛицо IN (SELECT ФизЛицо ИЗ врФЛ Т ) 
				   |                                                                           и (Сотрудник.ДатаУвольнения = ДатаВремя(1,1,1) или Сотрудник.ДатаУвольнения >= &ДатаСреза)
				   |                                                                           И Организация = &Организация) КАК РаботникиОрганизацийСрезПоследних
				   |		) КАК РаботникиОрганизацийСрезПоследних
				   |	ПО ФизЛица.ФизЛицо = РаботникиОрганизацийСрезПоследних.Сотрудник.ФизЛицо
				   
				   |LEFT OUTER JoIN РегистрСведений.ФИОФизЛиц.СрезПоследних(, ФизЛицо IN (SELECT ФизЛицо ИЗ врФЛ Т )) РЕгФИО ON Истина
				   |
				   |";
				   Запрос.УстановитьПараметр("ДатаСреза",Дата);
				   Запрос.УстановитьПараметр("Организация",Организация);
				   тбл = запрос.Выполнить().Выгрузить();
				   
				   итТбл.Колонки.Добавить("РукОргДлж",Новый ОписаниеТипов("Строка"));
				   итТбл.Колонки.Добавить("РукОрг",Новый ОписаниеТипов("Строка"));
					   
				   Если ТБл.Количество()>0 Тогда
					   
					   Если СокрлП(ТБл[0].Фамилия)="" ТОгда
						   пИмя = Тбл[0].ФЛимя;
					   ИНаче
						   пИмя = СокрЛП(ТБл[0].Фамилия)+" "+Врег(Лев(ТБл[0].Имя,1))+"."+Врег(Лев(ТБл[0].Отчество,1))+".";
					   КонецесЛИ;
					   
					   итТбл[0].РукОргДлж = ТБл[0].Длж+Символы.ПС+СокрЛП(Организация);
					   итТбл[0].РукОрг = пИмя;
				   КонецЕсли;
				   
	
КонецПроцедуры

Функция УбратьООО_ЗАО(Зн)
	
	Зн = СтрЗаменить(Зн,"  "," ");
	Зн = СтрЗаменить(Зн,"Общество с ограниченной ответственностью","ООО");
	Зн = СтрЗаменить(Зн,"Общество с Ограниченной Ответственностью","ООО");
	Зн = СтрЗаменить(Зн,"Открытое акционерное общество ","ОАО");
	Зн = СтрЗаменить(Зн,"Открытое Акционерное Общество ","ОАО");
	Зн = СтрЗаменить(Зн,"Закрытое акционерное общество ","ЗАО");
	Зн = СтрЗаменить(Зн,"Закрытое Акционерное Общество ","ЗАО");
	
	Возврат Зн;
	
КонецФункции

Функция ДанныеШапка(НадоГЗ=Ложь)
	Организация = СсылкаНаОбъект.Организация;
	Дата = СсылкаНаОбъект.Дата;
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	               |	CASE WHEN &НАдоГЗ THEN РеестрУслугУслуги.Контрагент.НаименованиеПолное
				   |         ELSE РеестрУслугУслуги.Организация.НаименованиеПолное 
				   |         END КАК Организация,
				   
	               |	CASE WHEN &НАдоГЗ THEN РеестрУслугУслуги.КонтрагентГенЗаказчик.НаименованиеПолное 
				   |         ELSE РеестрУслугУслуги.Контрагент.НаименованиеПолное 
				   |         END КАК Заказчик,
				   
	               |	CASE WHEN &НАдоГЗ THEN РеестрУслугУслуги.КонтрагентГенЗаказчик 
				   |         ELSE РеестрУслугУслуги.Контрагент 
				   |         END КАК Контрагент,
				   
				   |	CASE WHEN &НАдоГЗ THEN РеестрУслугУслуги.КонтрагентГенЗаказчик.КонтрагентНаПечать
				   |         ELSE РеестрУслугУслуги.Контрагент.КонтрагентНаПечать
				   |         END КАК КонтрагентНаПечать,	// Алексей, 19.08.2020, РН-Бурение Ханты 3 вида реестров
				   
	               |	CASE WHEN &НАдоГЗ THEN ISNULL(ДокПод.ФИО,""       "") 
				   |         ELSE ISNULL(ДокИсп.Сотрудник,Значение(Справочник.уатСотрудники.ПустаяСсылка)) 
				   |         END КАК пГлОпер,
				   
	               |	CASE WHEN &НАдоГЗ THEN ISNULL(ДокГЗ.ФИО,""       "") 
				   |         ELSE ISNULL(ДокПод.ФИО,""       "") 
				   |         END КАК зкзРуководитель,
				   
	               |	CASE WHEN (&НАдоГЗ = true  и ПОДСТРОКА(ISNULL(ДокГЗ.Должность,"" ""),  1, 1) <> "" "")
				   |              THEN ДокГЗ.Должность
				   |         WHEN (&НАдоГЗ = false и ПОДСТРОКА(ISNULL(ДокПод.Должность,"" ""), 1, 1) <> "" "")
				   |              THEN ДокПод.Должность 
				   |         ELSE "" "" 
				   |         END КАК ЗкзТхт,
				   
	               |	CASE WHEN &НАдоГЗ THEN РеестрУслугУслуги.ДоговорГЗ 
				   |         ELSE РеестрУслугУслуги.Договор 
				   |         END КАК Договор,
				   
				   |	CASE WHEN &НАдоГЗ THEN РеестрУслугУслуги.Ссылка.ДоговорГЗ.Номер
				   |         ELSE РеестрУслугУслуги.Ссылка.Договор.Номер
				   |         END КАК НомерДоговора,	// Алексей, 19.08.2020, РН-Бурение Ханты 3 вида реестров
				   
				   |	CASE WHEN &НАдоГЗ THEN РеестрУслугУслуги.Ссылка.ДоговорГЗ.Дата 
				   |         ELSE РеестрУслугУслуги.Ссылка.Договор.Дата
				   |         END КАК ДатаДоговора,	// Алексей, 19.08.2020, РН-Бурение Ханты 3 вида реестров
				   
	               |	CASE WHEN (&НАдоГЗ и ПОДСТРОКА(ISNULL(ДокПод.Должность,"" ""), 1, 1) <> "" "")
				   |              THEN ДокПод.Должность 
				   |         ELSE ""                                                                                "" 
				   |         END КАК ДлжОпер,
				   
				   
	               |	РеестрУслугУслуги.Номер,
	               |	""                      "" Дата,
	               |	""                      "" максДата,
	               |	""                      "" минДата,
	               |	""                      "" ГлОпер,
	               |	""                                                                  "" Дов,
	               |	""                      "" Месяц,
				   |	""                      "" ДатаДоговораФ,	// Алексей, 19.08.2020, РН-Бурение Ханты 3 вида реестров
	               |	РеестрУслугУслуги.Дата Дт,
	               |	РеестрУслугУслуги.ЦО КАК ЦО,
	               |	КонтактнаяИнформация.Представление КАК Телефон,
	               |	РеестрУслугУслуги.Договор.ИмяЗаказчика ИмяЗаказчик,
	               |	РеестрУслугУслуги.Договор.ИмяИсполнителя ИмяИсполнитель,
	               |	РеестрУслугУслуги.Договор.ДопТекстВПодвал ДопТекстВПодвал,
				   |    ДокТб.МаксДт мкДт,
				   |    ДокТб.МинДт мнДт,
				   |    ""Кол-во часов"" ЧасыШапка
	               |ИЗ
	               |	Документ.РеестрУслуг КАК РеестрУслугУслуги
				   
				   |      LEFT OUTER JOIN (SELECT Ссылка, MAX(ПутевойЛист.ДатаВыезда) МаксДт,MIN(ПутевойЛист.ДатаВыезда) МинДт
				   |						 FROM Документ.РеестрУслуг.Услуги ДокТб 
				   |                        WHERE ДокТб.Ссылка = &СС
				   |					 GROUP BY Ссылка) ДокТб ON Истина
				   
				   |     LEFT OUTER JOIN Документ.РеестрУслуг.ПодписиЗаказчик ДокПод ON ДокПод.Ссылка = РеестрУслугУслуги.Ссылка и ДокПод.НомерСтроки = 1
				   
				   |     LEFT OUTER JOIN Документ.РеестрУслуг.ПодписиГенЗаказчик ДокГЗ ON ДокГЗ.Ссылка = РеестрУслугУслуги.Ссылка и ДокГЗ.НомерСтроки = 1
				   
				   |     LEFT OUTER JOIN Документ.РеестрУслуг.ПодписиИсполнитель ДокИсп  ON ДокИсп.Ссылка = РеестрУслугУслуги.Ссылка и ДокИсп.НомерСтроки = 1
				   
				   |		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.КонтактнаяИнформация КАК КонтактнаяИнформация
	               |		ПО ДокИсп.Сотрудник.ФизЛицо = КонтактнаяИнформация.Объект
	               |			И (КонтактнаяИнформация.Вид = ЗНАЧЕНИЕ(Справочник.ВидыКонтактнойИнформации.ТелефонСлужебный))
	               |			И (КонтактнаяИнформация.Тип = ЗНАЧЕНИЕ(Перечисление.ТипыКонтактнойИнформации.Телефон))
				   |
	               |ГДЕ
	               |	РеестрУслугУслуги.Ссылка = &СС";
				   Запрос.УстановитьПараметр("сс",СсылкаНаОбъект);
				   Запрос.УстановитьПараметр("НадоГЗ",НадоГЗ);
				   
				   
				   ТБл = Запрос.Выполнить().Выгрузить();
				   Тбл.Колонки.Добавить("СуммаПрописью",Новый ОписаниеТипов("Строка"));
				   
				   Если Тбл.Количество()>0 Тогда
					   
					   Если НадоГЗ=ЛОжь ТОгда
						   С = уатОбщегоНазначенияТиповые.ДанныеФизЛица(Организация,Тбл[0].пГлОпер.ФизЛицо,Дата);
						   ТБл[0].длжОпер = ""+СокрЛП(С.Должность)+Символы.ПС+СокрЛП(Организация);
						   Тбл[0].ГлОпер = уатОбщегоНазначенияТиповые.уатФамилияИнициалыФизЛица(Тбл[0].пГлОпер.ФизЛицо);
						   Тбл[0].Дов =  СокрЛП(Тбл[0].пГлОпер.Доверенность);
					   ИНаче
						   ТБл[0].длжОпер = ""+СокрЛП(ТБл[0].длжОпер)+Символы.ПС+УбратьООО_ЗАО(СокрЛП(ТБл[0].Организация));
						   Тбл[0].ГлОпер = СокрЛП(Тбл[0].пГлОпер);
					   КонецЕСЛИ;
					   
					   //Сделаем красивый переход страницы для названия фирмы
					   пС = Тбл[0].ЗкзТхт;
					   номПС = МАКС(Найти(пС," ООО"),Найти(пС," ЗАО"),Найти(пС," ОАО"));
					   Если номПС<>0 ТОгда
						   Тбл[0].ЗкзТхт = Лев(пС,номПС-1)+Символы.ПС+Сред(пС,номПС);
					   КонецеСЛИ;
					   
					   //Добавим название заказчика в подвал
					   пС = Тбл[0].ЗкзТхт;
					   Если МАКС(Найти(пС," ООО"),Найти(пС," ЗАО"),Найти(пС," ОАО"),Найти(пС,СокрЛП(Тбл[0].Контрагент)))=0 ТОгда
						Тбл[0].ЗкзТхт = пС+Символы.ПС+УбратьООО_ЗАО(СокрЛП(Тбл[0].Заказчик));   
					   КонецеСЛИ;
					   
					   
					   Тбл[0].Дата = Формат(Тбл[0].Дт,"ДФ=dd.MM.yyyy");
					   Тбл[0].Месяц = Формат(Тбл[0].Дт,"ДФ='MMMM yyyy ""г.""'");
					   Тбл[0].МаксДата = Формат(Тбл[0].мкДт,"ДФ=dd.MM.yyyy");
					   Тбл[0].МинДата = Формат(Тбл[0].мнДт,"ДФ=dd.MM.yyyy");
					   Тбл[0].ДатаДоговораФ = Формат(Тбл[0].ДатаДоговора,"ДФ=dd.MM.yyyy");
					   
					   
					   Если СокрлП(Тбл[0].ИмяЗаказчик)="" ТОгда
						   Тбл[0].ИмяЗаказчик = "Заказчик";	
					   КонецеСЛИ;
					   Если СокрлП(Тбл[0].ИмяИсполнитель)="" ТОгда
						   Тбл[0].ИмяИсполнитель = "Исполнитель";	
					   КонецеСЛИ;
					   
					   ПолучитьРуководителяПредприятия(Тбл);
				   КонецеСЛИ;
				   
				   
				   Стк = новый Структура;
				   
				   Для каждого колТбл из Тбл.Колонки Цикл
						Стк.вставить(колТбл.Имя);   
				   КонецЦикла;
				   
				   
				   Если Тбл.Количество()<>0 ТОгда
					   ЗаполнитьЗначенияСвойств(Стк,ТБл[0]);
				   КонецеСЛИ;
				   
				   
				   
				   Возврат Стк;
	
КонецФункции




Процедура Печать(Элемент = неопределено,Индикатор1=0,НадоГЗ=Ложь) Экспорт
	
	Перем ИДДанные, СистемаМониторинга;
	
	ИтогоПробег = 0;
	
	ТабДок = Новый ТабличныйДокумент;
	ТабДок.Очистить();
	
	сткДок = ДанныеШапка();
	
	Макет = ПолучитьМакет("РеестрПоБСМТС");
	Заголовок = Макет.ПолучитьОбласть("Заголовок");
	ТС = Макет.ПолучитьОбласть("ТС");
	ИтогоТС = Макет.ПолучитьОбласть("ИтогоТС");
	ОбластьПодвал = Макет.ПолучитьОбласть("Подвал");
	ОбластьШапкаТаблицы = Макет.ПолучитьОбласть("ШапкаТаблицы");
	ОбластьПодвалТаблицы = Макет.ПолучитьОбласть("ПодвалТаблицы");
	Детали = Макет.ПолучитьОбласть("Детали");
	Детали1С = Макет.ПолучитьОбласть("Детали1С");
	
	Заголовок.Параметры.Заполнить(сткДок);
	Заголовок.Параметры.ДатаДоговора = Формат(сткДок.ДатаДоговора,"ДФ=dd.MM.yyyy");
	ТабДок.Вывести(Заголовок);
	ТабДок.Вывести(ОбластьШапкаТаблицы);
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	РеестрУслугУслуги.ПутевойЛист КАК ПутевойЛист,
		|	ПРЕДСТАВЛЕНИЕ(РеестрУслугУслуги.ПутевойЛист) КАК ПутевойЛистПредставление,
		|	РеестрУслугУслуги.ТС КАК ТС,
		|	ПРЕДСТАВЛЕНИЕ(РеестрУслугУслуги.ТС) КАК ТСПредставление,
		|	РеестрУслугУслуги.Пробег КАК ПробегРеестр,
		|	РеестрУслугУслуги.ПутевойЛист.ДатаВыезда КАК ПЛДата,
		|	РеестрУслугУслуги.ПутевойЛист.Номер КАК ПЛНомер,
		|	РеестрУслугУслуги.ПутевойЛист.ДатаВыезда КАК ПЛДатаВыезда,
		|	РеестрУслугУслуги.ПутевойЛист.ДатаВозвращения КАК ПЛДатаВозвращения,
		|	ЕСТЬNULL(ксДанныеАтографа.ПараметрыБСМТС, ""Нет данных"") КАК ПараметрыБСМТС,
		|	ОшибкиБСМТС.ПричинаНеисправности КАК ПричинаНеисправности,
		|	РеестрУслугУслуги.ТС.ГаражныйНомер КАК ГаражныйНомер,
		|	РеестрУслугУслуги.ТС.ГосударственныйНомер КАК ГосударственныйНомер,
		|	РеестрУслугУслуги.ТС.ИДвСистемеНавигации КАК ИДвСистемеНавигации
		|ИЗ
		|	Документ.РеестрУслуг.Услуги КАК РеестрУслугУслуги
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ксДанныеАтографа КАК ксДанныеАтографа
		|		ПО РеестрУслугУслуги.ПутевойЛист = ксДанныеАтографа.ПутевойЛист
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ОшибкиБСМТС КАК ОшибкиБСМТС
		|		ПО РеестрУслугУслуги.ПутевойЛист = ОшибкиБСМТС.ПутЛист
		|ГДЕ
		|	РеестрУслугУслуги.Ссылка = &Ссылка
		|
		|УПОРЯДОЧИТЬ ПО
		|	ТС,
		|	ПЛДата
		|ИТОГИ
		|	СУММА(ПробегРеестр)
		|ПО
		|	ОБЩИЕ,
		|	ТС";
	
	Запрос.УстановитьПараметр("Ссылка",СсылкаНаОбъект);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаОбщийИтог = РезультатЗапроса.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
	ВыборкаОбщийИтог.Следующий();
	
	ВыборкаТС = ВыборкаОбщийИтог.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
	Пока ВыборкаТС.Следующий() Цикл
		ИтогоПробегПоТС = 0;
		ТС.Параметры.Заполнить(ВыборкаТС);
		ТС.ОБласть(1,2,1,8).ЦветФона = WebЦвета.Желтый; //СветлоЖелтый
		Если ПустаяСтрока(ВыборкаТС.ИДвСистемеНавигации)Тогда
			ТС.ОБласть(1,5,1,5).ЦветФона = WebЦвета.ЛососьСветлый;; 
		КонецЕсли;	
		ТабДок.Вывести(ТС, ВыборкаТС.Уровень());

		Выборка = ВыборкаТС.Выбрать();
		Пока Выборка.Следующий() Цикл
			Если Выборка.ПараметрыБСМТС = "Нет данных" Тогда
				//Сообщить("По ТС г/н " + ВыборкаТС.ТС.ГаражныйНомер + " нет данных из БСМТС по пут. листу - " + Выборка.ПутевойЛистПредставление);
				Детали.Параметры.Заполнить(Выборка);
				ТабДок.Вывести(Детали);
				Продолжить;
			КонецЕсли;	
			
			Стк = Выборка.ПараметрыБСМТС.Получить();
			СткПараметровБСМТС = Новый Структура("TotalDistance,AverageSpeed,MaxSpeed,MoveDuration,ParkDuration,Engine1Motohours,Engine1MHOnParks,Sensor100ON_dur");
			ОбработатьПараметрыБСМТС(Стк,СткПараметровБСМТС);
			//Если глОбщий.ИмяПользователяС1С() Тогда
			//	Детали1С.Параметры.Заполнить(СткПараметровБСМТС);
			//	Детали1С.Параметры.Заполнить(Выборка);
			//	Детали1С.Параметры.ПутевойЛистТекст = "Путевой лист № " + Выборка.ПЛНомер + " : " + Формат(Выборка.ПЛДатаВыезда,"ДЛФ=T") + " - " + Формат(Выборка.ПЛДатаВозвращения,"ДЛФ=T");
			//	ТабДок.Вывести(Детали1С);
			//Иначе
				Детали.Параметры.Заполнить(СткПараметровБСМТС);
				Детали.Параметры.Заполнить(Выборка);
				Детали.Параметры.TotalDistance = Окр(СткПараметровБСМТС.TotalDistance,1);
				ТабДок.Вывести(Детали);
			//КонецЕсли;	
			ИтогоПробегПоТС = ИтогоПробегПоТС + Окр(СткПараметровБСМТС.TotalDistance,1);
			ИтогоПробег = ИтогоПробег + Окр(СткПараметровБСМТС.TotalDistance,1);
		КонецЦикла;
		
		
		//ИтогоТС.Параметры.Заполнить(ВыборкаТС);
		//ИтогоТС.Параметры.ИтогоПробегПоТС = ИтогоПробегПоТС;
		//ТабДок.Вывести(ИтогоТС, ВыборкаТС.Уровень());
		
	КонецЦикла;
	
	ОбластьПодвалТаблицы.Параметры.ИтогоПробег = ИтогоПробег;
	ОбластьПодвалТаблицы.Параметры.Заполнить(ВыборкаОбщийИтог);
	ТабДок.Вывести(ОбластьПодвалТаблицы);
	
	ОбластьПодвал.Параметры.Заполнить(сткДок);
	ТабДок.Вывести(ОбластьПодвал);
	ТабДок.ТолькоПросмотр = Истина;
	ТабДок.ОтображатьСетку = Ложь;
	ТабДок.ОтображатьЗаголовки = Ложь;
	ТабДок.АвтоМасштаб = Истина;
	ТабДок.ОриентацияСтраницы = ОриентацияСтраницы.Ландшафт;
	ТабДок.Показать();
	
	
КонецПроцедуры

Процедура ОбработатьПараметрыБСМТС(ПараметрыБСМТС,СткПараметровБСМТС)
	Для Каждого ХХХ Из СткПараметровБСМТС Цикл
		Если ПараметрыБСМТС.Получить(ХХХ.Ключ) = Неопределено Тогда
			СткПараметровБСМТС[ХХХ.Ключ] = "Нет параметра из БСМТС";
		Иначе
			СткПараметровБСМТС[ХХХ.Ключ] = ПараметрыБСМТС.Получить(ХХХ.Ключ);
		КонецЕсли;	
	КонецЦикла;	
КонецПроцедуры	

