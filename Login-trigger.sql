--SWITCH TO MY PREFERRED DATABASE
USE MYDATABASE
GO
--QUERY TO CREATE THE TRIGGER

CREATE TRIGGER TR_LOGIN
ON ALL SERVER
FOR LOGON
AS 
BEGIN
	--DECLARATION OF VARIABLE TO STORE LOGIN NAME

	DECLARE @log varchar(50)
	SET @log = Original_login()
	IF (SELECT COUNT(*) FROM sys.dm_exec_sessions
	WHERE is_user_process = 1 AND @log = original_login_name) > 1 --CONDITION TO ACCEPT ONLY ONE CONNECTION
	BEGIN
		--Prevent any further action
		ROLLBACK
		PRINT 'CONNECTION DENIED BY ' + @log
	END
END
GO

-- To read the error log
EXEC sp_readerrorlog
GO

--Query to drop all triggers on server
DROP TRIGGER TR_LOGIN ON ALL SERVER
GO