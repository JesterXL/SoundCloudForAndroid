/**
 * Component.as
 * Keith Peters
 * version 0.9.1
 * 
 * Base class for all components
 * 
 * Copyright (c) 2010 Keith Peters
 * 
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 * 
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 * 
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 * 
 * 
 * 
 * Components with text make use of the font PF Ronda Seven by Yuusuke Kamiyamane
 * This is a free font obtained from http://www.dafont.com/pf-ronda-seven.font
 */
 
package com.bit101.components
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.filters.DropShadowFilter;

	public class Component extends Sprite
	{
		
		// NOTE: Flex 4 introduces DefineFont4, which is used by default and does not work in native text fields.
		// Use the embedAsCFF="false" param to switch back to DefineFont4. In earlier Flex 4 SDKs this was cff="false".
		// So if you are using the Flex 3.x sdk compiler, switch the embed statment below to expose the correct version.
		
		// Flex 4.x sdk:
		[Embed(source="/assets/pf_ronda_seven.ttf", embedAsCFF="false", fontName="PF Ronda Seven", mimeType="application/x-font")]
		// Flex 3.x sdk:
		//[Embed(source="/assets/fonts/pf_ronda_seven.ttf", fontName="PF Ronda Seven", mimeType="application/x-font")]
		private var Ronda:Class;
		
		protected var _width:Number = 0;
		protected var _height:Number = 0;
		protected var _tag:int = -1;
		protected var _enabled:Boolean = true;
		private var _currentState:String = "";
		
		
		private var invalidateDrawFlag:Boolean = true;
		private var invalidatePropertiesFlag:Boolean = true;
		protected var initialDraw:Boolean = true;
		private var queuedMethods:Array; // Vector someday, but too much configuration for users
		private var _oldState:String = "";
		
		protected function get oldState():String { return _oldState; }
		
		
		
		public static const DRAW:String = "draw";

		/**
		 * Constructor
		 * @param parent The parent DisplayObjectContainer on which to add this component.
		 * @param xpos The x position to place this component.
		 * @param ypos The y position to place this component.
		 */
		public function Component(parent:DisplayObjectContainer = null, xpos:Number = 0, ypos:Number =  0)
		{
			move(xpos, ypos);
			if(parent != null)
			{
				parent.addChild(this);
			}
			init();
		}
		
		/**
		 * Initilizes the component.
		 */
		protected function init():void
		{
			addChildren();
			invalidate();
			visible = false;
		}
		
		/**
		 * Overriden in subclasses to create child display objects.
		 */
		protected function addChildren():void
		{
			
		}
		
		/**
		 * DropShadowFilter factory method, used in many of the components.
		 * @param dist The distance of the shadow.
		 * @param knockout Whether or not to create a knocked out shadow.
		 */
		protected function getShadow(dist:Number, knockout:Boolean = false):DropShadowFilter
		{
			return new DropShadowFilter(dist, 45, Style.DROPSHADOW, 1, dist, dist, .3, 1, knockout);
		}
		
		private function addInvalidateListener():void
		{
			addEventListener(Event.ENTER_FRAME, onInvalidate);
		}
		
		protected function invalidateDraw():void
		{
			invalidateDrawFlag = true;
			addInvalidateListener();
		}
		
		protected function invalidateProperties():void
		{
			invalidatePropertiesFlag = true;
			addInvalidateListener();
		}
		
		/**
		 * Marks the component to be redrawn on the next frame.
		 */
		protected function invalidate():void
		{
			invalidateDrawFlag = true;
			invalidatePropertiesFlag = true;
			addInvalidateListener();
		}
		
		
		
		
		///////////////////////////////////
		// public methods
		///////////////////////////////////
		
		/**
		 * Utility method to set up usual stage align and scaling.
		 */
		public static function initStage(stage:Stage):void
		{
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
		}
		
		/**
		 * Moves the component to the specified position.
		 * @param xpos the x position to move the component
		 * @param ypos the y position to move the component
		 */
		public function move(xpos:Number, ypos:Number):void
		{
			x = Math.round(xpos);
			y = Math.round(ypos);
		}
		
		/**
		 * Sets the size of the component.
		 * @param w The width of the component.
		 * @param h The height of the component.
		 */
		public function setSize(w:Number, h:Number):void
		{
			_width = w;
			_height = h;
			invalidateDraw();
		}
		
		protected function commitProperties():void
		{
			
		}
		
		/**
		 * Abstract draw function.
		 */
		public function draw():void
		{
			dispatchEvent(new Event(Component.DRAW));
		}
		
		
		protected function callNextFrame(methodToCall:Function, ... rest):void
		{
			if(queuedMethods == null)
				queuedMethods = [];
			
			queuedMethods.push(new Method(this, methodToCall, rest));
			addEventListener(Event.ENTER_FRAME, onQueuedMethods);
		}
		
		///////////////////////////////////
		// event handlers
		///////////////////////////////////
		
		/**
		 * Called one frame after invalidate is called.
		 */
		protected function onInvalidate(event:Event):void
		{
			removeEventListener(Event.ENTER_FRAME, onInvalidate);
			if(invalidatePropertiesFlag)
			{
				invalidatePropertiesFlag = false;
				commitProperties();
			}
			if(invalidateDrawFlag)
			{
				invalidateDrawFlag = false;
				draw();
			}
			
			if(initialDraw)
			{
				initialDraw = false;
				onExitState(oldState);
				onEnterState(_currentState);
				visible = true;
			}
		}
		
		private function onQueuedMethods(event:Event):void
		{
			removeEventListener(Event.ENTER_FRAME, onQueuedMethods);
			
			if(queuedMethods)
			{
				var len:int = queuedMethods.length;
				for(var index:uint = 0; index < len; index++)
				{
					var method:Method = queuedMethods[index];
					method.func.apply(method.scope, method.params);
				}
				queuedMethods = [];
			}
		}
		
		
		
		
		///////////////////////////////////
		// getter/setters
		///////////////////////////////////
		
		/**
		 * Sets/gets the width of the component.
		 */
		override public function set width(w:Number):void
		{
			_width = w;
			invalidateDraw();
			dispatchEvent(new Event(Event.RESIZE));
		}
		override public function get width():Number
		{
			return _width;
		}
		
		/**
		 * Sets/gets the height of the component.
		 */
		override public function set height(h:Number):void
		{
			_height = h;
			invalidateDraw();
			dispatchEvent(new Event(Event.RESIZE));
		}
		override public function get height():Number
		{
			return _height;
		}
		
		/**
		 * Sets/gets in integer that can identify the component.
		 */
		public function set tag(value:int):void
		{
			_tag = value;
		}
		public function get tag():int
		{
			return _tag;
		}
		
		/**
		 * Overrides the setter for x to always place the component on a whole pixel.
		 */
		override public function set x(value:Number):void
		{
			super.x = Math.round(value);
		}
		
		/**
		 * Overrides the setter for y to always place the component on a whole pixel.
		 */
		override public function set y(value:Number):void
		{
			super.y = Math.round(value);
		}

		/**
		 * Sets/gets whether this component is enabled or not.
		 */
		public function set enabled(value:Boolean):void
		{
			_enabled = value;
			mouseEnabled = mouseChildren = _enabled;
			alpha = _enabled ? 1.0 : 0.5;
		}
		public function get enabled():Boolean
		{
			return _enabled;
		}
		
		/**
		 * Get's the current state of the component. Default is empty String. 
		 * @return 
		 * 
		 */		
		public function get currentState():String { return _currentState; }
		
		/**
		 * Set's the current state of the component.  If value changes, onExitState is called, and then onEnterState. 
		 * @param value
		 * 
		 */		
		public function set currentState(value:String):void
		{
			if(_currentState == value)
			{
				return;
			}
			else
			{
				if(initialDraw == false)
				{
					_oldState = _currentState;
					_currentState = value;
					onExitState(_oldState);
					onEnterState(_currentState);
				}
				else
				{
					_currentState = value;
				}
			}
		}
		
		protected function onEnterState(state:String):void {}
		
		protected function onExitState(oldState:String):void {}
		
		protected function addChildIfYouCan(child:DisplayObject):DisplayObject
		{
			if(child == null) return null;
			
			if(contains(child) == false)
			{
				return addChild(child);
			}
			else
			{
				return child;
			}
		}

	}
}

class Method
{
	public var scope:*;
	public var func:Function;
	public var params:Array;
	
	public function Method(scope:*, func:Function, params:Array=null):void
	{
		this.scope                      = scope;
		this.func                       = func;
		this.params                     = params;
	}
}