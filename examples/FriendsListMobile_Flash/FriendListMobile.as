﻿/*	Copyright (c) 2010, Adobe Systems Incorporated	All rights reserved.		Redistribution and use in source and binary forms, with or without	modification, are permitted provided that the following conditions are	met:		* Redistributions of source code must retain the above copyright notice,	this list of conditions and the following disclaimer.		* Redistributions in binary form must reproduce the above copyright	notice, this list of conditions and the following disclaimer in the	documentation and/or other materials provided with the distribution.		* Neither the name of Adobe Systems Incorporated nor the names of its	contributors may be used to endorse or promote products derived from	this software without specific prior written permission.		THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS	IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO,	THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR	PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR	CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,	EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,	PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR	PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF	LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING	NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS	SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.*/package  {		import flash.display.MovieClip;	import flash.events.Event;	import flash.events.MouseEvent;	import flash.display.Stage;	import flash.display.StageAlign;	import flash.display.StageScaleMode;	import flash.media.StageWebView;		import com.facebook.graph.FacebookMobile;	import com.facebook.graph.controls.Distractor;		import demo.controls.GraphicButton;	import demo.events.FacebookDemoEvent;	import demo.models.FriendModel;	import demo.views.FriendDetail;	import demo.views.FriendsList;	import demo.views.UserInfo;		public class FriendListMobile extends MovieClip {				//Place your application id here.		protected static const APP_ID:String = 'YOUR_APP_ID';		//Place your specified site URL for your app here. This is needed for clearing cookies when logging out.		protected static const SITE_URL:String = 'http://your.site.url/';		//Extended permission to access other parts of the user's profile that may be private, or if your application needs to publish content to Facebook on a user's behalf.		protected var extendedPermissions:Array = ["publish_stream","user_website","user_status","user_about_me"];				public var userInfo:UserInfo;		public var loginBtn:GraphicButton;		public var friendDetail:FriendDetail;		public var friendList:FriendsList;				public var distractor:Distractor;		public var bg:DistractorOverlay;		public var friendsModel:FriendModel;				protected var selectedUserInfo:Object = {};				public function FriendListMobile() {			// constructor code			stage.align = StageAlign.TOP_LEFT;			stage.scaleMode = StageScaleMode.NO_SCALE;			init();		}				protected function init():void {			configUI();			addEventListeners();						FacebookMobile.init(APP_ID, onHandleInit, null);		}				protected function configUI():void {			loginBtn.label = 'Login';			loginBtn.setSize(440, 60);			loginBtn.setStyle('font', '_sans');			loginBtn.setStyle('size', 25);						friendsModel = new FriendModel();						distractor = new Distractor();			friendDetail.visible = false;						bg = new DistractorOverlay();			bg.visible = true;			addChild(bg);						distractor.x = 120			distractor.y = 310; 						bg.addChild(distractor);		}				protected function addEventListeners():void {			loginBtn.addEventListener(MouseEvent.MOUSE_DOWN, handleLoginClick, false, 0, true);			friendDetail.addEventListener(Event.CLOSE, onCloseDialog, false, 0, true);			friendsModel.addEventListener(Event.COMPLETE, onFriendsComplete, false, 0, true);			friendList.addEventListener(FacebookDemoEvent.FRIEND_SELECTED, onFriendSelected, false, 0, true);		}				/**		 * Pops up detail view for a selected friend.		 **/		protected function showFriendDetail():void {			bg.visible = true;						friendDetail.visible = true;			friendDetail.data = selectedUserInfo;						this.setChildIndex(friendDetail, this.numChildren - 1);		}				/**		 * Event Handler Close DetailView		 **/		protected function onCloseDialog(event:Event):void {			friendDetail.visible = false;			bg.visible = false;		}				/**		 * Event Handler user selects from the friend list.		 **/		protected function onFriendSelected(event:FacebookDemoEvent):void {			selectedUserInfo = event.data;			showFriendDetail();		}		 		/**		 * Event Handler User clicks Login button.		 **/		protected function handleLoginClick(event:MouseEvent):void {			bg.visible = true;						loginUser();		}				/**		 * Event Handler User clicks on Logout button.		 **/		protected function handleLogOutClick(event:MouseEvent):void {			FacebookMobile.logout(handleLogout, SITE_URL);						loginBtn.label = 'Login';			loginBtn.addEventListener(MouseEvent.MOUSE_DOWN, handleLoginClick, false, 0, true);						friendList.clear();			userInfo.clear();						bg.visible = true;		}				/**		 * Event Handler once logged out.		 **/		protected function handleLogout(response:Object):void {			bg.visible = false;		}				/**		 * Event Handler FacebookMobile initializes application.		 * Application will check if user is return to application, 		 * if not user is prompted to log in.		 **/		protected function onHandleInit(response:Object, fail:Object):void {			if (response) {				updateView(response.uid, response);			} else {				loginUser();			}		}				/**		 * Updates UI for views 		 **/		protected function updateView(id:String, data):void {			userInfo.id = id;			userInfo.data = data;						loginBtn.label = 'Log Out';			loginBtn.addEventListener(MouseEvent.MOUSE_DOWN, handleLogOutClick);			loginBtn.removeEventListener(MouseEvent.MOUSE_DOWN, handleLoginClick);						friendsModel.load();		}				/**		 * Preforms a login call to application. Mobile application takes in an instance 		 * StageView class.		 **/		protected function loginUser():void {			FacebookMobile.login(handleLogin, stage, extendedPermissions, new StageWebView());		}				/**		 * Event Handler once user logs in.		 **/		protected function handleLogin(response:Object, fail:Object):void {			bg.visible = false;			FacebookMobile.api('/me', handleUserInfo);		}				/**		 * Event Handler for users information.		 **/		protected function handleUserInfo(response:Object, fail:Object):void {			if (response) {				updateView(response.id, response);			}		}				/**		 * Event Handler FriendModel information has been loaded.		 **/		protected function onFriendsComplete(event:Event):void {			bg.visible = false;			friendList.dataProvider = friendsModel.dataProvider;		}	}	}