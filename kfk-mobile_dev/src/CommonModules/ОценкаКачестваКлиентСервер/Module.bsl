
Функция ПолучитьОценку(ПроцентСоответсвия) Экспорт
	
	Оценка = 0;
	
	Если ПроцентСоответсвия >= 95 Тогда 
		Оценка = 5;
	ИначеЕсли ПроцентСоответсвия >= 90 И ПроцентСоответсвия < 95 Тогда
		Оценка = 4;
	ИначеЕсли ПроцентСоответсвия >= 85 И ПроцентСоответсвия < 90 Тогда
		Оценка = 3;
	ИначеЕсли ПроцентСоответсвия >= 80 И ПроцентСоответсвия < 85 Тогда
		Оценка = 2;
	ИначеЕсли ПроцентСоответсвия >= 75 И ПроцентСоответсвия < 80 Тогда
		Оценка = 1;
	КонецЕсли;
	
	Возврат Оценка;
	
КонецФункции