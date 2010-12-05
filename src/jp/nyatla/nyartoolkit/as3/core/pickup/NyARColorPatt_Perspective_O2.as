/* 
 * PROJECT: NyARToolkitAS3
 * --------------------------------------------------------------------------------
 * This work is based on the original ARToolKit developed by
 *   Hirokazu Kato
 *   Mark Billinghurst
 *   HITLab, University of Washington, Seattle
 * http://www.hitl.washington.edu/artoolkit/
 *
 * The NyARToolkitAS3 is AS3 edition ARToolKit class library.
 * Copyright (C)2010 Ryo Iizuka
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
 *	http://nyatla.jp/nyatoolkit/
 *	<airmail(at)ebony.plala.or.jp> or <nyatla(at)nyatla.jp>
 * 
 */
package jp.nyatla.nyartoolkit.as3.core.pickup 
{
	import jp.nyatla.as3utils.*;
	import jp.nyatla.nyartoolkit.as3.core.types.*;
	import jp.nyatla.nyartoolkit.as3.core.rasterreader.*;
	import jp.nyatla.nyartoolkit.as3.core.raster.rgb.*;
	import jp.nyatla.nyartoolkit.as3.*;
	/**
	 * 遠近法を使ったパースペクティブ補正をかけて、ラスタ上の四角形から
	 * 任意解像度の矩形パターンを作成します。
	 *
	 */
	public class NyARColorPatt_Perspective_O2 implements INyARColorPatt
	{
		private var _edge:NyARIntPoint2d=new NyARIntPoint2d();
		protected var _patdata:Vector.<int>;
		protected var _resolution:int;
		protected var _size:NyARIntSize;
		private var _pixelreader:NyARRgbPixelReader_INT1D_X8R8G8B8_32;
		private static const BUFFER_FORMAT:int=NyARBufferType.INT1D_X8R8G8B8_32;
		private var _perspective_reader:NyARPerspectiveRasterReader;
		private function initializeInstance(i_width:int,i_height:int,i_point_per_pix:int,i_input_raster_type:int):void
		{
			//assert i_width>2 && i_height>2;
			this._resolution=i_point_per_pix;	
			this._size=new NyARIntSize(i_width,i_height);
			this._patdata = new Vector.<int>(i_height*i_width);
			this._pixelreader=new NyARRgbPixelReader_INT1D_X8R8G8B8_32(this._patdata,this._size);
			this._perspective_reader=new NyARPerspectiveRasterReader(i_input_raster_type);
			return;		
		}
		public function NyARColorPatt_Perspective_O2(...args:Array)
		{
			switch(args.length) {
			case 1:
				if (args[0] is NyAS3Const_Inherited) {
					//blank
					return;
				}
			case 3:
				{	//public function NyARColorPatt_Perspective_O2_1(i_width:int,i_height:int,i_point_per_pix:int):void
					NyARColorPatt_Perspective_O2_1((int)(args[0]),(int)(args[1]),(int)(args[2]));
					return;
				}
			case 5:
				{	//public function NyARColorPatt_Perspective_O2_2(i_width:int,i_height:int,i_point_per_pix:int,i_edge_percentage:int,i_input_raster_type:int):void
					NyARColorPatt_Perspective_O2_2((int)(args[0]),(int)(args[1]),(int)(args[2]),(int)(args[3]),(int)(args[4]));
					return;
				}
			default:
				break;
			}
			throw new NyARException();
		}		
		
		
		/**
		 * コンストラクタです。エッジサイズ0,InputRaster=ANYでインスタンスを作成します。
		 * @param i_width
		 * 取得画像の解像度幅
		 * @param i_height
		 * 取得画像の解像度高さ
		 * @param i_point_per_pix
		 * 1ピクセルあたりの縦横サンプリング数。2なら2x2=4ポイントをサンプリングする。
		 */
		public function NyARColorPatt_Perspective_O2_1(i_width:int,i_height:int,i_point_per_pix:int):void
		{
			initializeInstance(i_width,i_height,i_point_per_pix,NyARBufferType.NULL_ALLZERO);
			this._edge.setValue_3(0,0);
			return;
		}
		/**
		 * コンストラクタです。エッジサイズ,InputRasterTypeを指定してインスタンスを作成します。
		 * @param i_width
		 * 取得画像の解像度幅
		 * @param i_height
		 * 取得画像の解像度高さ
		 * @param i_point_per_pix
		 * 1ピクセルあたりの解像度
		 * @param i_edge_percentage
		 * エッジ幅の割合(ARToolKit標準と同じなら、25)
		 * @param i_input_raster_type
		 * 入力ラスタの種類
		 */
		public function NyARColorPatt_Perspective_O2_2(i_width:int,i_height:int,i_point_per_pix:int,i_edge_percentage:int,i_input_raster_type:int):void
		{
			initializeInstance(i_width,i_height,i_point_per_pix,i_input_raster_type);
			this._edge.setValue_3(i_edge_percentage, i_edge_percentage);
			return;
		}	
		public function setEdgeSizeByPercent(i_x_percent:int,i_y_percent:int,i_resolution:int):void
		{
			//assert(i_x_percent>=0);
			//assert(i_y_percent>=0);
			this._edge.setValue_3(i_x_percent, i_y_percent);
			this._resolution=i_resolution;
			return;
		}

		
		public function getWidth():int
		{ 
			return this._size.w ;
		}
		
		public function getHeight():int
		{ 
			return this._size.h ;
		}
		
		public function getSize():NyARIntSize
		{ 
			return this._size ;
		}
		
		public function getRgbPixelReader():INyARRgbPixelReader
		{ 
			return this._pixelreader ;
		}
		
		public function getBuffer():Object
		{ 
			return this._patdata ;
		}
		
		public function hasBuffer():Boolean
		{ 
			return this._patdata != null ;
		}
		
		public function wrapBuffer( i_ref_buf:Object ):void
		{ 
			NyARException.notImplement() ;
		}
		
		public function getBufferType():int
		{ 
			return BUFFER_FORMAT ;
		}
		
		public function isEqualBufferType( i_type_value:int ):Boolean
		{ 
			return BUFFER_FORMAT == i_type_value ;
		}

		/**
		 * @see INyARColorPatt#pickFromRaster
		 */
		public function pickFromRaster(image:INyARRgbRaster, i_vertexs:Vector.<NyARIntPoint2d>):Boolean
		{
			//遠近法のパラメータを計算
			return this._perspective_reader.read4Point_2(image, i_vertexs,this._edge.x,this._edge.y,this._resolution, this);
		}

	}
}
