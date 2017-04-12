# And what about SQLPS?
SQLPS is a set of extensions to Powershell for interacting with SQL Server.
#### I have several things that I Hate to See in T-SQL.
I was inspired this [article](http://michaeljswart.com/2010/08/ten-things-i-hate-to-see-in-t-sql/)
*Чуть позже подготовлю английскую версию.*

Я понимаю, что на сегодняшний день, если ты хорошо знаешь SQL, то тебе необязательно работать в пространстве скрипта .sql.
Вся работа с переменными похожа на - **Humiliation of variables(унижение переменных)**.
- Ты не можешь использовать переменные в Use, а только через хранимые процедуры EXEC.
- Ты не можешь использовать переменные в представлениях(View) никоим образом.
- Ты не можешь записать сразу несколько значений Select в одну переменную.
- Для перебора этих значений тебе обязательно понадобится Cursor.

В один момент я понял, что можно выйти за рамки .sql и почему бы не работать в привычной оболочке Powershell скрипта?
Смысл в том, что мы работаем с информацией о таблицах, о базе данных, необязательно работать ограничиваясь T-SQL.
В скрипте, который я выкладываю, была простая задача, сделать собственное представление несвязанных выборок между собой.

В последствии я выложу скрипты по пересозданию кластерных индексов, отсоединении SQL Constraints все это умещается в пару строк.
Скрипт в T-SQL получился бы огромным.

<p align="center">
<img src="http://image.prntscr.com/image/b5f6ed52e2c844d8b8ce3f3155a33824.png">
</p>

## sp_helpdb
Или другой пример, у нас есть хранимая процедура - sp_helpdb (Transact-SQL). Reports information about a specified database or all databases. 
Результат этой команды к мой БД будет примерно такой.
<p align="center">
<img src="http://image.prntscr.com/image/cde5ac86aa274481baf8ad33724032e1.png">
</p>
Но, что если мне хочется поработать с последним столбцом? status(Comma-separated list of values of database options that are currently set on the database.)

Задача преобразовать последний столбец так чтобы информация о Collation и Status была доступна в отдельных столбцах.
На выходе я получаю такой результат, при помощи работы с `Invoke-Sqlcmd`.

[Пример кода](https://github.com/dalred/Mystruggle/blob/Pshellish/Invoke/sp_helpdb)

<p align="center">
<img src="http://image.prntscr.com/image/1659f1d9d9d947ed9a891e5be33c4962.png">
</p>