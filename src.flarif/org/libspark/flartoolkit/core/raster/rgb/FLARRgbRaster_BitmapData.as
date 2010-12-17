/* 
 * PROJECT: FLARToolKit
 * --------------------------------------------------------------------------------
 * This work is based on the NyARToolKit developed by
 *   R.Iizuka (nyatla)
 * http://nyatla.jp/nyatoolkit/
 *
 * The FLARToolKit is ActionScript 3.0 version ARToolkit class library.
 * Copyright (C)2008 Saqoosha
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 * 
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 * 
 * For further information please contact.
 *	http://www.libspark.org/wiki/saqoosha/FLARToolKit
 *	<saq(at)saqoosha.net>
 * 
 */
package org.libspark.flartoolkit.core.raster.rgb
{
	import jp.nyatla.nyartoolkit.as3.core.raster.rgb.*;
	import jp.nyatla.nyartoolkit.as3.core.types.*;
	import jp.nyatla.nyartoolkit.as3.core.rasterreader.*;
	import org.libspark.flartoolkit.core.rasterreader.*;
	import org.libspark.flartoolkit.*;
	import jp.nyatla.as3utils.*;
	import flash.display.BitmapData;
	/**
	 * BitmapDataをデータに持つRasterクラス
	 */
	public class FLARRgbRaster_BitmapData extends NyARRgbRaster_BasicClass
	{
		private var _bitmapData:BitmapData;
		private var _rgb_reader:FLARRgbPixelReader_BitmapData;
		private var _is_attached:Boolean;
		/**
		 * function FLARRgbRaster_BitmapData_1(i_width:int,i_height:int,i_is_attached:Boolean)
		 * 指定したサイズのビットマップを持つインスタンスを生成する。
		 * function FLARRgbRaster_BitmapData_2(i_bmp:BitmapData)
		 * 指定した外部BitmapDataをラップしたインスタンスを生成する。
		 */
		public function FLARRgbRaster_BitmapData(...args:Array)
		{
			super(new NyAS3Const_Inherited());
			switch(args.length) {
			case 1:
				if (args[0] is NyAS3Const_Inherited) {
					return;
				}else if (args[0] is BitmapData) {
					override_FLARRgbRaster_BitmapData_2(BitmapData(args[0]));
					return;
				}
				break;
			case 3:
				if ((args[0] is int) && (args[1] is int) && (args[2] is Boolean))
				{
					override_FLARRgbRaster_BitmapData_1(int(args[0]), int(args[1]),Boolean(args[2]));
					return;
				}
				break;
			default:
			}			
			throw new FLARException();
		}
		public function override_FLARRgbRaster_BitmapData_1(i_width:int,i_height:int,i_is_attached:Boolean):void
		{
			super.overload_NyARRgbRaster_BasicClass(i_width, i_height, NyARBufferType.OBJECT_AS3_BitmapData);
			this._is_attached = i_is_attached;
			this._bitmapData = i_is_attached?new BitmapData(i_width,i_height,false):null;
			this._rgb_reader = new FLARRgbPixelReader_BitmapData(this._bitmapData);
		}
		public function override_FLARRgbRaster_BitmapData_2(i_bmp:BitmapData):void
		{
			super.overload_NyARRgbRaster_BasicClass(i_bmp.width, i_bmp.height, NyARBufferType.OBJECT_AS3_BitmapData);
			this._is_attached = true;
			this._bitmapData = i_bmp;
			this._rgb_reader = new FLARRgbPixelReader_BitmapData(this._bitmapData);
		}
		
		public override function getRgbPixelReader():INyARRgbPixelReader
		{
			return this._rgb_reader;
		}
		public override function getBuffer():Object
		{
			return this._bitmapData;
		}
		public override function hasBuffer():Boolean
		{
			return this._bitmapData != null;
		}
		public function getBitmapData():BitmapData
		{
			return this._bitmapData;
		}
		public override function wrapBuffer(i_ref_buf:Object):void
		{
			if (this._is_attached) {
				throw new FLARException();
			}
			this._bitmapData = BitmapData(i_ref_buf);
			this._rgb_reader.switchBuffer(i_ref_buf);
		}		
	}
}

