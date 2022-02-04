#Область ОбработчикиСобытийЭлементовТаблицыФормыВопросы

&НаКлиенте
Процедура ВопросыОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	Для Каждого Строка Из ВыбранноеЗначение Цикл
		//@skip-check query-in-loop
		ДобавитьВыбранныеЗначения(Строка);
	КонецЦикла;
КонецПроцедуры

&НаКлиенте
Процедура ОчиститьВопросы(Команда)
	Объект.Вопросы.Очистить();
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ПодборВопросов(Команда)
	Если Не ЗначениеЗаполнено(Объект.Тест) Тогда
		ПоказатьПредупреждение( , "Заполните поле ""Тест"" перед подбором");
		Возврат;
	КонецЕсли;
	ПараметрыФормы = Новый Структура("ЗакрыватьприВыборе, МножественныйВыбор, РежимВыбора", Ложь, Истина, Истина);
	ОткрытьФорму("Справочник.Вопросы.ФормаВыбора", ПараметрыФормы, Элементы.Вопросы, , , , ,
		РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ДобавитьВыбранныеЗначения(ВыбранноеЗначение)
	Если ВыбранноеЗначение.ЭтоГруппа Тогда
		Запрос = Новый Запрос;
		Запрос.Текст =
		"ВЫБРАТЬ
		|	Вопросы.Ссылка,
		|	Вопросы.ЭтоГруппа
		|ИЗ
		|	Справочник.Вопросы КАК Вопросы
		|ГДЕ
		|	Вопросы.Родитель = &Родитель";

		Запрос.УстановитьПараметр("Родитель", ВыбранноеЗначение);
		РезультатЗапроса = Запрос.Выполнить();
		ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();

		Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
			Если ВыборкаДетальныеЗаписи.ЭтоГруппа Тогда
				//@skip-check query-in-loop
				ДобавитьВыбранныеЗначения(ВыборкаДетальныеЗаписи.Ссылка);
			Иначе
				ДобавитьНовыйЭлемент(ВыборкаДетальныеЗаписи.Ссылка);
			КонецЕсли;
		КонецЦикла;
	Иначе
		ДобавитьНовыйЭлемент(ВыбранноеЗначение);
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура ДобавитьНовыйЭлемент(ВыбранноеЗначение)
	НайденныеСтроки = Объект.Вопросы.НайтиСтроки(Новый Структура("Вопрос", ВыбранноеЗначение));
	Если НайденныеСтроки.Количество() = 0 Тогда
		НоваяСтрока = Объект.Вопросы.Добавить();
		НоваяСтрока.Вопрос = ВыбранноеЗначение;
	КонецЕсли;
КонецПроцедуры

#КонецОбласти