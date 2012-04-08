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
package jp.nyatla.nyartoolkit.as3.core.match 
{
	import jp.nyatla.nyartoolkit.as3.core.raster.*;
	import jp.nyatla.nyartoolkit.as3.core.raster.rgb.*;
	import jp.nyatla.nyartoolkit.as3.core.rasterreader.*;
	import jp.nyatla.nyartoolkit.as3.core.types.*;
	import jp.nyatla.as3utils.*;
	
	public class NyARMatchPattDeviationColorData
	{
		private var _data:Vector.<int>;
		private var _pow:Number;
		private var _size:NyARIntSize;
		//
		private var _optimize_for_mod:int;
		public function getData():Vector.<int>
		{
			return this._data;
		}
		public function getPow():Number
		{
			return this._pow;
		}
						  
		public function NyARMatchPattDeviationColorData(i_width:int,i_height:int)
		{
			this._size = new NyARIntSize(i_width, i_height);
			this._data=new Vector.<int>(this._size.w*this._size.h*3);
			return;
		}
		private var _last_input_raster:INyARRaster=null;
		private var _last_drv:IRasterDriver;
		
		/**
		 * NyARRasterからパターンデータをセットします。
		 * この関数は、データを元に所有するデータ領域を更新します。
		 * @param i_buffer
		 * @throws NyARException 
		 */
		public function setRaster_1(i_raster:INyARRgbRaster):void
		{
			//ドライバの生成
			if(this._last_input_raster!=i_raster){
				this._last_drv=IRasterDriver(i_raster.createInterface(IRasterDriver));
				this._last_input_raster=i_raster;
			}
			this._pow=this._last_drv.makeColorData(this._data);
			return;
		}
		/**
		 * 回転方向を指定してラスタをセットします。
		 * @param i_reader
		 * @param i_direction
		 * 右上の位置です。0=1象限、1=2象限、、2=3象限、、3=4象限の位置に対応します。
		 * @throws NyARException
		 */
		public function setRaster_2(i_raster:INyARRgbRaster,i_direction:int):void
		{
			var width:int=this._size.w;
			var height:int=this._size.h;
			var i_number_of_pix:int = width * height;
			var reader:INyARRgbPixelDriver=i_raster.getRgbPixelDriver();
			var rgb:Vector.<int>=new Vector.<int>(3);
			var out:Vector.<int>=this._data;
			var ave:int;//<PV/>
			var x:int, y:int;
			//<平均値計算>
			ave = 0;
			for (y= height - 1; y >= 0; y--) {
				for(x=width-1;x>=0;x--){
					reader.getPixel(x,y,rgb);
					ave += rgb[0]+rgb[1]+rgb[2];
				}
			}
			//<平均値計算>
			ave=i_number_of_pix*255*3-ave;
			ave =255-(ave/ (i_number_of_pix * 3));//(255-R)-ave を分解するための事前計算

			var sum:int = 0,w_sum:int;
			var input_ptr:int=i_number_of_pix*3-1;
			switch(i_direction)
			{
			case 0:
				for(y=height-1;y>=0;y--){
					for(x=width-1;x>=0;x--){
						reader.getPixel(x,y,rgb);
						w_sum = (ave - rgb[2]) ;out[input_ptr--] = w_sum;sum += w_sum * w_sum;//B
						w_sum = (ave - rgb[1]) ;out[input_ptr--] = w_sum;sum += w_sum * w_sum;//G
						w_sum = (ave - rgb[0]) ;out[input_ptr--] = w_sum;sum += w_sum * w_sum;//R
					}
				}
				break;
			case 1:
				for(x=0;x<width;x++){
					for(y=height-1;y>=0;y--){
						reader.getPixel(x,y,rgb);
						w_sum = (ave - rgb[2]) ;out[input_ptr--] = w_sum;sum += w_sum * w_sum;//B
						w_sum = (ave - rgb[1]) ;out[input_ptr--] = w_sum;sum += w_sum * w_sum;//G
						w_sum = (ave - rgb[0]) ;out[input_ptr--] = w_sum;sum += w_sum * w_sum;//R
					}
				}
				break;
			case 2:
				for(y=0;y<height;y++){
					for(x=0;x<width;x++){
						reader.getPixel(x,y,rgb);
						w_sum = (ave - rgb[2]) ;out[input_ptr--] = w_sum;sum += w_sum * w_sum;//B
						w_sum = (ave - rgb[1]) ;out[input_ptr--] = w_sum;sum += w_sum * w_sum;//G
						w_sum = (ave - rgb[0]) ;out[input_ptr--] = w_sum;sum += w_sum * w_sum;//R
					}
				}
				break;
			case 3:
				for(x=width-1;x>=0;x--){
					for(y=0;y<height;y++){
						reader.getPixel(x,y,rgb);
						w_sum = (ave - rgb[2]) ;out[input_ptr--] = w_sum;sum += w_sum * w_sum;//B
						w_sum = (ave - rgb[1]) ;out[input_ptr--] = w_sum;sum += w_sum * w_sum;//G
						w_sum = (ave - rgb[0]) ;out[input_ptr--] = w_sum;sum += w_sum * w_sum;//R
					}
				}
				break;
				
			}
			//<差分値計算>
			//<差分値計算(FORの1/8展開)/>
			var p:Number=Math.sqrt((Number)(sum));
			this._pow=(p!=0.0?p:0.0000001);
		}	
		
		
		
		
		
		/**
		 * INT1D_X8R8G8B8_32形式の入力ドライバ。
		 * @param i_buf
		 * @param i_number_of_pix
		 * @param i_for_mod
		 * @param o_out
		 * pow値
		 * @return
		 */
		private static function setRaster_INT1D_X8R8G8B8_32(i_buf:Vector.<int>,i_number_of_pix:int,i_for_mod:int,o_out:Vector.<int>):Number
		{
			//i_buffer[XRGB]→差分[R,G,B]変換			
			var i:int;
			var ave:int;//<PV/>
			var rgb:int;//<PV/>
			//<平均値計算(FORの1/8展開)>
			ave = 0;
			for(i=i_number_of_pix-1;i>=i_for_mod;i--){
				rgb = i_buf[i];ave += ((rgb >> 16) & 0xff) + ((rgb >> 8) & 0xff) + (rgb & 0xff);
			}
			for (;i>=0;) {
				rgb = i_buf[i];ave += ((rgb >> 16) & 0xff) + ((rgb >> 8) & 0xff) + (rgb & 0xff);i--;
				rgb = i_buf[i];ave += ((rgb >> 16) & 0xff) + ((rgb >> 8) & 0xff) + (rgb & 0xff);i--;
				rgb = i_buf[i];ave += ((rgb >> 16) & 0xff) + ((rgb >> 8) & 0xff) + (rgb & 0xff);i--;
				rgb = i_buf[i];ave += ((rgb >> 16) & 0xff) + ((rgb >> 8) & 0xff) + (rgb & 0xff);i--;
				rgb = i_buf[i];ave += ((rgb >> 16) & 0xff) + ((rgb >> 8) & 0xff) + (rgb & 0xff);i--;
				rgb = i_buf[i];ave += ((rgb >> 16) & 0xff) + ((rgb >> 8) & 0xff) + (rgb & 0xff);i--;
				rgb = i_buf[i];ave += ((rgb >> 16) & 0xff) + ((rgb >> 8) & 0xff) + (rgb & 0xff);i--;
				rgb = i_buf[i];ave += ((rgb >> 16) & 0xff) + ((rgb >> 8) & 0xff) + (rgb & 0xff);i--;
			}
			//<平均値計算(FORの1/8展開)/>
			ave=i_number_of_pix*255*3-ave;
			ave =255-(ave/ (i_number_of_pix * 3));//(255-R)-ave を分解するための事前計算

			var sum:int = 0,w_sum:int;
			var input_ptr:int=i_number_of_pix*3-1;
			//<差分値計算(FORの1/8展開)>
			for (i = i_number_of_pix-1; i >= i_for_mod;i--) {
				rgb = i_buf[i];
				w_sum = (ave - (rgb & 0xff)) ;o_out[input_ptr--] = w_sum;sum += w_sum * w_sum;//B
				w_sum = (ave - ((rgb >> 8) & 0xff)) ;o_out[input_ptr--] = w_sum;sum += w_sum * w_sum;//G
				w_sum = (ave - ((rgb >> 16) & 0xff)) ;o_out[input_ptr--] = w_sum;sum += w_sum * w_sum;//R
			}
			for (; i >=0;) {
				rgb = i_buf[i];i--;
				w_sum = (ave - (rgb & 0xff)) ;o_out[input_ptr--] = w_sum;sum += w_sum * w_sum;//B
				w_sum = (ave - ((rgb >> 8) & 0xff)) ;o_out[input_ptr--] = w_sum;sum += w_sum * w_sum;//G
				w_sum = (ave - ((rgb >> 16) & 0xff)) ;o_out[input_ptr--] = w_sum;sum += w_sum * w_sum;//R
				rgb = i_buf[i];i--;
				w_sum = (ave - (rgb & 0xff)) ;o_out[input_ptr--] = w_sum;sum += w_sum * w_sum;//B
				w_sum = (ave - ((rgb >> 8) & 0xff)) ;o_out[input_ptr--] = w_sum;sum += w_sum * w_sum;//G
				w_sum = (ave - ((rgb >> 16) & 0xff)) ;o_out[input_ptr--] = w_sum;sum += w_sum * w_sum;//R
				rgb = i_buf[i];i--;
				w_sum = (ave - (rgb & 0xff)) ;o_out[input_ptr--] = w_sum;sum += w_sum * w_sum;//B
				w_sum = (ave - ((rgb >> 8) & 0xff)) ;o_out[input_ptr--] = w_sum;sum += w_sum * w_sum;//G
				w_sum = (ave - ((rgb >> 16) & 0xff)) ;o_out[input_ptr--] = w_sum;sum += w_sum * w_sum;//R
				rgb = i_buf[i];i--;
				w_sum = (ave - (rgb & 0xff)) ;o_out[input_ptr--] = w_sum;sum += w_sum * w_sum;//B
				w_sum = (ave - ((rgb >> 8) & 0xff)) ;o_out[input_ptr--] = w_sum;sum += w_sum * w_sum;//G
				w_sum = (ave - ((rgb >> 16) & 0xff)) ;o_out[input_ptr--] = w_sum;sum += w_sum * w_sum;//R
				rgb = i_buf[i];i--;
				w_sum = (ave - (rgb & 0xff)) ;o_out[input_ptr--] = w_sum;sum += w_sum * w_sum;//B
				w_sum = (ave - ((rgb >> 8) & 0xff)) ;o_out[input_ptr--] = w_sum;sum += w_sum * w_sum;//G
				w_sum = (ave - ((rgb >> 16) & 0xff)) ;o_out[input_ptr--] = w_sum;sum += w_sum * w_sum;//R
				rgb = i_buf[i];i--;
				w_sum = (ave - (rgb & 0xff)) ;o_out[input_ptr--] = w_sum;sum += w_sum * w_sum;//B
				w_sum = (ave - ((rgb >> 8) & 0xff)) ;o_out[input_ptr--] = w_sum;sum += w_sum * w_sum;//G
				w_sum = (ave - ((rgb >> 16) & 0xff)) ;o_out[input_ptr--] = w_sum;sum += w_sum * w_sum;//R
				rgb = i_buf[i];i--;
				w_sum = (ave - (rgb & 0xff)) ;o_out[input_ptr--] = w_sum;sum += w_sum * w_sum;//B
				w_sum = (ave - ((rgb >> 8) & 0xff)) ;o_out[input_ptr--] = w_sum;sum += w_sum * w_sum;//G
				w_sum = (ave - ((rgb >> 16) & 0xff)) ;o_out[input_ptr--] = w_sum;sum += w_sum * w_sum;//R
				rgb = i_buf[i];i--;
				w_sum = (ave - (rgb & 0xff)) ;o_out[input_ptr--] = w_sum;sum += w_sum * w_sum;//B
				w_sum = (ave - ((rgb >> 8) & 0xff)) ;o_out[input_ptr--] = w_sum;sum += w_sum * w_sum;//G
				w_sum = (ave - ((rgb >> 16) & 0xff)) ;o_out[input_ptr--] = w_sum;sum += w_sum * w_sum;//R
			}
			//<差分値計算(FORの1/8展開)/>
			var p:Number=Math.sqrt((Number)(sum));
			return p!=0.0?p:0.0000001;
		}
		/**
		 * ANY形式の入力ドライバ。
		 * @param i_buf
		 * @param i_number_of_pix
		 * @param i_for_mod
		 * @param o_out
		 * pow値
		 * @return
		 * @throws NyARException 
		 */
		private static function setRaster_ANY(i_reader:INyARRgbPixelReader,i_size:NyARIntSize,i_number_of_pix:int,o_out:Vector.<int>):Number
		{
			var width:int=i_size.w;
			var rgb:Vector.<int>=new Vector.<int>(3);
			var ave:int;//<PV/>
			var x:int, y:int;
			//<平均値計算>
			ave = 0;
			for(y=i_size.h-1;y>=0;y--){
				for(x=width-1;x>=0;x--){
					i_reader.getPixel(x,y,rgb);
					ave += rgb[0]+rgb[1]+rgb[2];
				}
			}
			//<平均値計算>
			ave=i_number_of_pix*255*3-ave;
			ave =255-(ave/ (i_number_of_pix * 3));//(255-R)-ave を分解するための事前計算

			var sum:int = 0,w_sum:int;
			var input_ptr:int=i_number_of_pix*3-1;
			//<差分値計算>
			for(y=i_size.h-1;y>=0;y--){
				for(x=width-1;x>=0;x--){
					i_reader.getPixel(x,y,rgb);
					w_sum = (ave - rgb[2]) ;o_out[input_ptr--] = w_sum;sum += w_sum * w_sum;//B
					w_sum = (ave - rgb[1]) ;o_out[input_ptr--] = w_sum;sum += w_sum * w_sum;//G
					w_sum = (ave - rgb[0]) ;o_out[input_ptr--] = w_sum;sum += w_sum * w_sum;//R
				}
			}
			//<差分値計算(FORの1/8展開)/>
			var p:Number=Math.sqrt((Number)(sum));
			return p!=0.0?p:0.0000001;
		}
	}
}


/**
 * Rasterからデータを生成するインタフェイス。
 */
interface IRasterDriver
{
	/**
	 * この関数は、参照するラスタの差分画像データを取得する。
	 * @param o_out
	 * 差分画像データ
	 * @return
	 * pow値
	 */
	function makeColorData(o_out:Vector.<int>):Number;
}
class RasterDriverFactory
{
	public static function createDriver(i_raster:INyARRgbRaster):IRasterDriver
	{
		switch(i_raster.getBufferType())
		{
		case NyARBufferType.INT1D_X8R8G8B8_32:
			return new NyARMatchPattDeviationDataDriver_INT1D_X8R8G8B8_32(i_raster);
		default:
			break;
		}
		return new NyARMatchPattDeviationDataDriver_RGBAny(i_raster);
	}
}
//
//	画像ドライバ
//

class NyARMatchPattDeviationDataDriver_INT1D_X8R8G8B8_32 implements NyARMatchPattDeviationColorData.IRasterDriver
{
	private var _ref_raster:INyARRgbRaster;
	public function NyARMatchPattDeviationDataDriver_INT1D_X8R8G8B8_32(i_raster:INyARRgbRaster)
	{
		this._ref_raster=i_raster;
	}
	public function makeColorData(o_out:Vector.<int>):Number
	{
		//i_buffer[XRGB]→差分[R,G,B]変換			
		var i:int;
		var rgb:int;//<PV/>
		//<平均値計算(FORの1/8展開)>
		var ave:int;//<PV/>
		var buf:Vector.<int>=(Vector.<int>)(this._ref_raster.getBuffer());
		var size:NyARIntSize=this._ref_raster.getSize();
		var number_of_pix:int=size.w*size.h;
		var optimize_mod:int=number_of_pix-(number_of_pix%8);
		ave=0;
		for(i=number_of_pix-1;i>=optimize_mod;i--){
			rgb = buf[i];ave += ((rgb >> 16) & 0xff) + ((rgb >> 8) & 0xff) + (rgb & 0xff);
		}
		for (;i>=0;) {
			rgb = buf[i];ave += ((rgb >> 16) & 0xff) + ((rgb >> 8) & 0xff) + (rgb & 0xff);i--;
			rgb = buf[i];ave += ((rgb >> 16) & 0xff) + ((rgb >> 8) & 0xff) + (rgb & 0xff);i--;
			rgb = buf[i];ave += ((rgb >> 16) & 0xff) + ((rgb >> 8) & 0xff) + (rgb & 0xff);i--;
			rgb = buf[i];ave += ((rgb >> 16) & 0xff) + ((rgb >> 8) & 0xff) + (rgb & 0xff);i--;
			rgb = buf[i];ave += ((rgb >> 16) & 0xff) + ((rgb >> 8) & 0xff) + (rgb & 0xff);i--;
			rgb = buf[i];ave += ((rgb >> 16) & 0xff) + ((rgb >> 8) & 0xff) + (rgb & 0xff);i--;
			rgb = buf[i];ave += ((rgb >> 16) & 0xff) + ((rgb >> 8) & 0xff) + (rgb & 0xff);i--;
			rgb = buf[i];ave += ((rgb >> 16) & 0xff) + ((rgb >> 8) & 0xff) + (rgb & 0xff);i--;
		}
		//<平均値計算(FORの1/8展開)/>
		ave=number_of_pix*255*3-ave;
		ave =255-(ave/ (number_of_pix * 3));//(255-R)-ave を分解するための事前計算

		var sum:int = 0,w_sum;
		var input_ptr:int=number_of_pix*3-1;
		//<差分値計算(FORの1/8展開)>
		for (i = number_of_pix-1; i >=optimize_mod;i--) {
			rgb = buf[i];
			w_sum = (ave - (rgb & 0xff)) ;o_out[input_ptr--] = w_sum;sum += w_sum * w_sum;//B
			w_sum = (ave - ((rgb >> 8) & 0xff)) ;o_out[input_ptr--] = w_sum;sum += w_sum * w_sum;//G
			w_sum = (ave - ((rgb >> 16) & 0xff)) ;o_out[input_ptr--] = w_sum;sum += w_sum * w_sum;//R
		}
		for (; i >=0;) {
			rgb = buf[i];i--;
			w_sum = (ave - (rgb & 0xff)) ;o_out[input_ptr--] = w_sum;sum += w_sum * w_sum;//B
			w_sum = (ave - ((rgb >> 8) & 0xff)) ;o_out[input_ptr--] = w_sum;sum += w_sum * w_sum;//G
			w_sum = (ave - ((rgb >> 16) & 0xff)) ;o_out[input_ptr--] = w_sum;sum += w_sum * w_sum;//R
			rgb = buf[i];i--;
			w_sum = (ave - (rgb & 0xff)) ;o_out[input_ptr--] = w_sum;sum += w_sum * w_sum;//B
			w_sum = (ave - ((rgb >> 8) & 0xff)) ;o_out[input_ptr--] = w_sum;sum += w_sum * w_sum;//G
			w_sum = (ave - ((rgb >> 16) & 0xff)) ;o_out[input_ptr--] = w_sum;sum += w_sum * w_sum;//R
			rgb = buf[i];i--;
			w_sum = (ave - (rgb & 0xff)) ;o_out[input_ptr--] = w_sum;sum += w_sum * w_sum;//B
			w_sum = (ave - ((rgb >> 8) & 0xff)) ;o_out[input_ptr--] = w_sum;sum += w_sum * w_sum;//G
			w_sum = (ave - ((rgb >> 16) & 0xff)) ;o_out[input_ptr--] = w_sum;sum += w_sum * w_sum;//R
			rgb = buf[i];i--;
			w_sum = (ave - (rgb & 0xff)) ;o_out[input_ptr--] = w_sum;sum += w_sum * w_sum;//B
			w_sum = (ave - ((rgb >> 8) & 0xff)) ;o_out[input_ptr--] = w_sum;sum += w_sum * w_sum;//G
			w_sum = (ave - ((rgb >> 16) & 0xff)) ;o_out[input_ptr--] = w_sum;sum += w_sum * w_sum;//R
			rgb = buf[i];i--;
			w_sum = (ave - (rgb & 0xff)) ;o_out[input_ptr--] = w_sum;sum += w_sum * w_sum;//B
			w_sum = (ave - ((rgb >> 8) & 0xff)) ;o_out[input_ptr--] = w_sum;sum += w_sum * w_sum;//G
			w_sum = (ave - ((rgb >> 16) & 0xff)) ;o_out[input_ptr--] = w_sum;sum += w_sum * w_sum;//R
			rgb = buf[i];i--;
			w_sum = (ave - (rgb & 0xff)) ;o_out[input_ptr--] = w_sum;sum += w_sum * w_sum;//B
			w_sum = (ave - ((rgb >> 8) & 0xff)) ;o_out[input_ptr--] = w_sum;sum += w_sum * w_sum;//G
			w_sum = (ave - ((rgb >> 16) & 0xff)) ;o_out[input_ptr--] = w_sum;sum += w_sum * w_sum;//R
			rgb = buf[i];i--;
			w_sum = (ave - (rgb & 0xff)) ;o_out[input_ptr--] = w_sum;sum += w_sum * w_sum;//B
			w_sum = (ave - ((rgb >> 8) & 0xff)) ;o_out[input_ptr--] = w_sum;sum += w_sum * w_sum;//G
			w_sum = (ave - ((rgb >> 16) & 0xff)) ;o_out[input_ptr--] = w_sum;sum += w_sum * w_sum;//R
			rgb = buf[i];i--;
			w_sum = (ave - (rgb & 0xff)) ;o_out[input_ptr--] = w_sum;sum += w_sum * w_sum;//B
			w_sum = (ave - ((rgb >> 8) & 0xff)) ;o_out[input_ptr--] = w_sum;sum += w_sum * w_sum;//G
			w_sum = (ave - ((rgb >> 16) & 0xff)) ;o_out[input_ptr--] = w_sum;sum += w_sum * w_sum;//R
		}
		//<差分値計算(FORの1/8展開)/>
		var p:Number=Math.sqrt((double) sum);
		return p!=0.0?p:0.0000001;
	}
}
class NyARMatchPattDeviationDataDriver_RGBAny implements NyARMatchPattDeviationColorData.IRasterDriver
{
	private var _ref_raster:INyARRgbRaster;
	public function NyARMatchPattDeviationDataDriver_RGBAny(INyARRgbRaster i_raster)
	{
		this._ref_raster=i_raster;
	}
	private var __rgb:Vector.<int>=new Vector.<int>(3);
	public function makeColorData(o_out:Vector.<int>):Number
	{
		var size:NyARIntSize=this._ref_raster.getSize();
		var pixdev:INyARRgbPixelDriver=this._ref_raster.getRgbPixelDriver();
		var rgb:Vector.<int>=this.__rgb;
		var width:int=size.w;
		//<平均値計算>
		var ave:int=0;//<PV/>
		for(var y:int=size.h-1;y>=0;y--){
			for(var x:int=width-1;x>=0;x--){
				pixdev.getPixel(x,y,rgb);
				ave += rgb[0]+rgb[1]+rgb[2];
			}
		}
		//<平均値計算>
		var number_of_pix:int=size.w*size.h;
		ave=number_of_pix*255*3-ave;
		ave =255-(ave/ (number_of_pix * 3));//(255-R)-ave を分解するための事前計算

		var sum:int = 0,w_sum;
		var input_ptr:int=number_of_pix*3-1;
		//<差分値計算>
		for(var y:int=size.h-1;y>=0;y--){
			for(var x:int=width-1;x>=0;x--){
				pixdev.getPixel(x,y,rgb);
				w_sum = (ave - rgb[2]) ;o_out[input_ptr--] = w_sum;sum += w_sum * w_sum;//B
				w_sum = (ave - rgb[1]) ;o_out[input_ptr--] = w_sum;sum += w_sum * w_sum;//G
				w_sum = (ave - rgb[0]) ;o_out[input_ptr--] = w_sum;sum += w_sum * w_sum;//R
			}
		}
		//<差分値計算(FORの1/8展開)/>
		var p:Number=Math.sqrt((double) sum);
		return p!=0.0?p:0.0000001;
		
	}
}	