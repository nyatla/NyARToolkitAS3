/* 
 * PROJECT: NyARToolkitAS3
 * --------------------------------------------------------------------------------
 *
 * The NyARToolkitCS is AS3 edition NyARToolKit class library.
 * Copyright (C)2010 Ryo Iizuka
 *
 * This work is based on the ARToolKit developed by
 *   Hirokazu Kato
 *   Mark Billinghurst
 *   HITLab, University of Washington, Seattle
 * http://www.hitl.washington.edu/artoolkit/
 * 
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Lesser General Public License as publishe
 * by the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 * 
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU Lesser General Public License for more details.
 * 
 * You should have received a copy of the GNU Lesser General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 * 
 * For further information please contact.
 *	http://nyatla.jp/nyatoolkit/
 *	<airmail(at)ebony.plala.or.jp> or <nyatla(at)nyatla.jp>
 * 
 */
package jp.nyatla.nyartoolkit.as3.core.raster
{
	import jp.nyatla.nyartoolkit.as3.core.*;
	import jp.nyatla.nyartoolkit.as3.core.types.*;
	import jp.nyatla.nyartoolkit.as3.core.pixeldriver.*;
	import jp.nyatla.nyartoolkit.as3.core.labeling.rlelabeling.*;
	import jp.nyatla.nyartoolkit.as3.core.squaredetect.*;
	/**
	 * このクラスは、0/ 255 の二値GrayscaleRasterです。
	 */
	public class NyARBinRaster extends NyARGrayscaleRaster
	{
		/**
		 * コンストラクタです。
		 * 画像のサイズパラメータを指定して、{@link NyARBufferType#INT2D_BIN_8}形式のバッファを持つインスタンスを生成します。
		 * このラスタは、内部参照バッファを持ちます。
		 * @param i_width
		 * ラスタのサイズ
		 * @param i_height
		 * ラスタのサイズ
		 * @throws NyARException
		 */
		public function NyARBinRaster(i_width:int,i_height:int,i_raster_type:int=-1,i_is_attach:Boolean=true)
		{
			super(i_width,i_height,i_raster_type==-1?NyARBufferType.INT1D_BIN_8:i_raster_type,i_is_attach);
		}
		/*
		 * この関数は、インスタンスの初期化シーケンスを実装します。
		 * コンストラクタから呼び出します。
		 * @param i_size
		 * ラスタのサイズ
		 * @param i_buf_type
		 * バッファ形式定数
		 * @param i_is_alloc
		 * 内部バッファ/外部バッファのフラグ
		 * @return
		 * 初期化に成功するとtrue
		 * @throws NyARException 
		 */
		protected override function initInstance(i_size:NyARIntSize,i_buf_type:int,i_is_alloc:Boolean):void
		{
			switch(i_buf_type)
			{
				case NyARBufferType.INT1D_BIN_8:
					this._buf = i_is_alloc?new Vector.<int>(i_size.w*i_size.h):null;
					break;
				default:
					super.initInstance(i_size, i_buf_type, i_is_alloc);
					return;
			}
			this._pixdrv=NyARGsPixelDriverFactory.createDriver(this);
			this._is_attached_buffer=i_is_alloc;
			return;
		}
		public override function createInterface(i_iid:Class):Object
		{
			if(i_iid==NyARLabeling_Rle_IRasterDriver){
				return NyARLabeling_Rle_RasterDriverFactory.createDriver(this);
			}
			if(i_iid==NyARContourPickup_IRasterDriver){
				return NyARContourPickup_ImageDriverFactory.createDriver(this);
			}
			throw new NyARException();
		}
	}
}