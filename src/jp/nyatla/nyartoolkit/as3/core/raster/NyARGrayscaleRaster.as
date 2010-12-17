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
package jp.nyatla.nyartoolkit.as3.core.raster 
{
	import jp.nyatla.nyartoolkit.as3.core.types.*;
	import jp.nyatla.nyartoolkit.as3.utils.as3.*;
	import jp.nyatla.nyartoolkit.as3.core.rasterreader.*;
	import jp.nyatla.nyartoolkit.as3.*;
	import jp.nyatla.as3utils.*;
	
	/**
	 * 1枚のグレースケール画像を定義するクラスです。画像データは内部保持/外部保持が選択可能です。
	 */
	public class NyARGrayscaleRaster extends NyARRaster_BasicClass
	{

		protected var _buf:Object;
		private var _impl:IdoFilterImpl;
		/**
		 * バッファオブジェクトがアタッチされていればtrue
		 */
		protected var _is_attached_buffer: Boolean;
		public function NyARGrayscaleRaster(...args:Array)
		{
			super(NyAS3Const_Inherited);
			switch(args.length) {
			case 1:
				if (args[0] is NyAS3Const_Inherited) {
					//blank
				}
				break;
			case 2:
				//NyARGrayscaleRaster(int i_width, int i_height)
				overload_NyARGrayscaleRaster2(int(args[0]), int(args[1]));
				break;
			case 3:
				//NyARGrayscaleRaster(int i_width, int i_height, boolean i_is_alloc)
				overload_NyARGrayscaleRaster3(int(args[0]), int(args[1]),Boolean(args[2]));
				break;
			case 4:
				//NyARGrayscaleRaster(int i_width, int i_height, int i_raster_type,boolean i_is_alloc)
				overload_NyARGrayscaleRaster4(int(args[0]), int(args[1]),int(args[2]),Boolean(args[3]));
				break;
			default:
				throw new NyARException();
			}			
		}

		protected function overload_NyARGrayscaleRaster2(i_width:int,i_height:int):void
		{
			super.overload_NyARRaster_BasicClass(i_width,i_height,NyARBufferType.INT1D_GRAY_8);
			if(!initInstance(this._size,NyARBufferType.INT1D_GRAY_8,true)){
				throw new NyARException();
			}
		}	
		protected function overload_NyARGrayscaleRaster3(i_width:int,i_height:int,i_is_alloc:Boolean):void
		{
			super.overload_NyARRaster_BasicClass(i_width,i_height,NyARBufferType.INT1D_GRAY_8);
			if(!initInstance(this._size,NyARBufferType.INT1D_GRAY_8,i_is_alloc)){
				throw new NyARException();
			}
		}
		/**
		 * @param i_width
		 * @param i_height
		 * @param i_raster_type
		 * NyARBufferTypeに定義された定数値を指定してください。
		 * @param i_is_alloc
		 * @throws NyARException
		 */
		protected function overload_NyARGrayscaleRaster4(i_width:int, i_height:int, i_raster_type:int, i_is_alloc:Boolean):void
		{
			super.overload_NyARRaster_BasicClass(i_width,i_height,i_raster_type);
			if(!initInstance(this._size,i_raster_type,i_is_alloc)){
				throw new NyARException();
			}
		}
		/**
		 * このクラスの初期化シーケンスです。コンストラクタから呼び出します。
		 * @param i_size
		 * @param i_buf_type
		 * @param i_is_alloc
		 * @return
		 */
		protected function initInstance(i_size:NyARIntSize,i_buf_type:int,i_is_alloc:Boolean):Boolean
		{
			switch (i_buf_type) {
			case NyARBufferType.INT1D_GRAY_8:
				this._impl=new IdoFilterImpl_INT1D_GRAY_8();
				this._buf = i_is_alloc ? new Vector.<int>(i_size.w * i_size.h) : null;
				break;
			default:
				return false;
			}
			this._is_attached_buffer = i_is_alloc;
			return true;
		}
		public override function getBuffer():Object
		{
			return this._buf;
		}
		/**
		 * インスタンスがバッファを所有するかを返します。
		 * コンストラクタでi_is_allocをfalseにしてラスタを作成した場合、
		 * バッファにアクセスするまえに、バッファの有無をこの関数でチェックしてください。
		 * @return
		 */
		public override function hasBuffer():Boolean
		{
			return this._buf!=null;
		}
		public override function wrapBuffer(i_ref_buf:Object):void
		{
			NyAS3Utils.assert(!this._is_attached_buffer);//バッファがアタッチされていたら機能しない。
			this._buf=i_ref_buf;
		}
		/**
		 * 指定した数値でラスタを埋めます。
		 * この関数は高速化していません。
		 * @param i_value
		 */
		public function fill(i_value:int):void
		{
			//assert (this.isEqualBufferType(this.getBufferType()));
			this._impl.fill(this,i_value);
		}

		/**
		 * ラスタの異解像度間コピーをします。
		 * @param i_input
		 * 入力ラスタ
		 * @param i_top
		 * 入力ラスタの左上点を指定します。
		 * @param i_left
		 * 入力ラスタの左上点を指定します。
		 * @param i_skip
		 * skip値。1なら等倍、2なら1/2倍、3なら1/3倍の偏重の画像を出力します。
		 * @param o_output
		 * 出力先ラスタ。このラスタの解像度は、w=(i_input.w-i_left)/i_skip,h=(i_input.h-i_height)/i_skipを満たす必要があります。
		 * 出力先ラスタと入力ラスタのバッファタイプは、同じである必要があります。
		 */
		public function copyTo(i_left:int,i_top:int,i_skip:int,o_output:NyARGrayscaleRaster):void
		{
			//assert (this.getSize().isInnerSize(i_left + o_output.getWidth() * i_skip, i_top+ o_output.getHeight() * i_skip));		
			//assert (this.isEqualBufferType(o_output.getBufferType()));
			this._impl.copyTo(this, i_left, i_top, i_skip, o_output);
			return;
		}
	}
}

////////////////////////////////////////////////////////////////////////////////
//ここからラスタドライバ
import jp.nyatla.nyartoolkit.as3.core.raster.*;
import jp.nyatla.nyartoolkit.as3.core.types.*;
interface IdoFilterImpl 
{
	function fill( i_raster:NyARGrayscaleRaster , i_value:int ):void ; 
	function copyTo( i_input:NyARGrayscaleRaster , i_left:int , i_top:int , i_skip:int , o_output:NyARGrayscaleRaster ):void;
}

class IdoFilterImpl_INT1D_GRAY_8 implements IdoFilterImpl
{
	public function fill(i_raster:NyARGrayscaleRaster,i_value:int):void
	{
		//assert (i_raster._buffer_type == NyARBufferType.INT1D_GRAY_8);
		var buf:Vector.<int> = (Vector.<int>)(i_raster.getBuffer());
		var size:NyARIntSize = i_raster.getSize();
		for (var i:int = size.h * size.w - 1; i >= 0; i--) {
			buf[i] = i_value;
		}			
	}

	public function copyTo(i_input:NyARGrayscaleRaster,i_left:int,i_top:int,i_skip:int,o_output:NyARGrayscaleRaster):void
	{
		//assert (i_input.getSize().isInnerSize(i_left + o_output.getWidth() * i_skip, i_top+ o_output.getHeight() * i_skip));		
		var input:Vector.<int> = (Vector.<int>)(i_input.getBuffer());
		var output:Vector.<int> = (Vector.<int>)(o_output.getBuffer());
		var pt_src:int, pt_dst:int;
		var dest_size:NyARIntSize = o_output.getSize();
		var src_size:NyARIntSize = i_input.getSize();
		var skip_src_y:int = (src_size.w - dest_size.w * i_skip) + src_size.w * (i_skip - 1);
		var pix_count:int = dest_size.w;
		var pix_mod_part:int = pix_count - (pix_count % 8);
		// 左上から1行づつ走査していく
		pt_dst = 0;
		pt_src = (i_top * src_size.w + i_left);
		for (var y:int = dest_size.h - 1; y >= 0; y -= 1) {
			var x:int;
			for (x = pix_count - 1; x >= pix_mod_part; x--) {
					output[pt_dst++] = input[pt_src];
					pt_src += i_skip;
			}
			for (; x >= 0; x -= 8) {
				output[pt_dst++] = input[pt_src];
				pt_src += i_skip;
				output[pt_dst++] = input[pt_src];
				pt_src += i_skip;
				output[pt_dst++] = input[pt_src];
				pt_src += i_skip;
				output[pt_dst++] = input[pt_src];
				pt_src += i_skip;
				output[pt_dst++] = input[pt_src];
				pt_src += i_skip;
				output[pt_dst++] = input[pt_src];
				pt_src += i_skip;
				output[pt_dst++] = input[pt_src];
				pt_src += i_skip;
				output[pt_dst++] = input[pt_src];
				pt_src += i_skip;
			}
			// スキップ
			pt_src += skip_src_y;
		}
		return;
	}
}