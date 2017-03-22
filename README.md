# And what about SQLPS?
SQLPS is a set of extensions to Powershell for interacting with SQL Server.
#### I have several things that I Hate to See in T-SQL.
*Чуть позже подготовлю английскую версию.*

Я понимаю что на сегодняшний день, если ты хорошо знаешь SQL, то тебе необязательно работать в пространстве скрипта .sql.
Вся работа с переменными похожа на - **Humiliation of variables(унижение переменных)**.
- Ты не можешь использовать переменные в Use, а только через хранимые процедуры EXEC.
- Ты не можешь использовать переменные в представлениях(View) никоим образом.
- Ты не можешь сразу несколько значений Select в одну переменную.
- Для перебора этих значений тебе обязательно понадобится Cursor.

В один момент я понял, что можно выйти за рамки .sql, и почему бы не работать в привычной оболочке например .PS1?
Смысл в том что мы работаем с информацией о таблицах, о базе данных, необязательно работать ограничиваясь T-SQL.
В скрипте который я выкладываю, была простая задача, сделать собственное представление несвязанных выборок между собой.

В последствии я выложу скрипты по пересозданию кластерных индексов, отсоединении SQL Constraints все это умещается в пару строк.
Но огромный скрипт получился бы в пространстве .sql.
<p align="center">
<img src="http://image.prntscr.com/image/b5f6ed52e2c844d8b8ce3f3155a33824.png">
</p>

