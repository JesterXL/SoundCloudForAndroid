package com.jxl.soundcloud
{
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	public class FavoritesCache extends EventDispatcher
	{
		public function FavoritesCache()
		{
			super();
		}
	}
}

package util
{
	
	import flash.data.SQLConnection;
	import flash.data.SQLStatement;
	import flash.data.SQLTransactionLockType;
	import flash.events.SQLEvent;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import util.TimedAlert;
	
	public class SqlDbCreate{
		
		
		public var createStmt:SQLStatement;
		
		public function CreateDB(file:File, connection:SQLConnection):void{
			
			createStmt = new SQLStatement();
			createStmt.sqlConnection = connection;
			
			createStmt.sqlConnection = connection;
			
			var sql:String = "";
			sql += "CREATE TABLE IF NOT EXISTS User(";
			sql += "    Wisp_ID TEXT,";
			sql += "    Username TEXT,";
			sql += "    Password TEXT,";
			sql += "    Elevation NUMERIC DEFAULT 25,";
			sql += "    Water NUMERIC,";
			sql += "    EvergreenNeedle NUMERIC,";
			sql += "    EvergreenBroad NUMERIC,";
			sql += "    DeciduousNeedle NUMERIC,";
			sql += "    DeciduousBroad NUMERIC,";
			sql += "    MixedForest NUMERIC,";
			sql += "    Wooded NUMERIC,";
			sql += "    WoodedGrass NUMERIC,";
			sql += "    ClosedShrub NUMERIC,";
			sql += "    OpenShrub NUMERIC,";
			sql += "    Grass NUMERIC,";0
			sql += "    Crops NUMERIC,";
			sql += "    Bare NUMERIC,";
			sql += "    Urban NUMERIC)";
			
			
			createStmt.text = sql;
			createStmt.execute();
			
			sql = "";
			sql += "CREATE TABLE IF NOT EXISTS Assets(";
			sql += "    ID Numeric,";
			sql += "    Name TEXT,";
			sql += "    Type TEXT,";
			sql += "    Lat NUMERIC,";
			sql += "    Lon NUMERIC,";
			sql += "    Elevation NUMERIC,";
			sql += "    Radius NUMERIC,";
			sql += "    Address Text,";
			sql += "    City Text,";
			sql += "    State Text,";
			sql += "    Zip Text)";
			
			createStmt.text = sql;
			createStmt.addEventListener(SQLEvent.RESULT, selectResult);
			createStmt.execute();
		}
		
		private function selectResult(evt:SQLEvent):void{
			createStmt.removeEventListener(SQLEvent.RESULT, selectResult);
			var ta:TimedAlert = new TimedAlert("Database Created", "");
		}
		
	}
	
}