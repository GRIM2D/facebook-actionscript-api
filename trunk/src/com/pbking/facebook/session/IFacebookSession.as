package com.pbking.facebook.session
{
	import com.pbking.facebook.FacebookCall;
	import com.pbking.facebook.delegates.IFacebookCallDelegate;
	
	public interface IFacebookSession
	{
		function get is_connected():Boolean;
		
		function get api_key():String; 

		function get secret():String; 
	
		function get session_key():String; 
		
		function get expires():Number; 
	
		function get uid():String;

		function get api_version():String;
		
		function post(call:FacebookCall):IFacebookCallDelegate; 

		function addConnectionCallback(callback:Function):void;
	}
}