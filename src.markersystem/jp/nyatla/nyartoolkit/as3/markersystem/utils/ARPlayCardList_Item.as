/* 
 * PROJECT: NyARToolkit(Extension)
 * --------------------------------------------------------------------------------
 * The NyARToolkit is Java edition ARToolKit class library.
 * Copyright (C)2008-2009 Ryo Iizuka
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
package jp.nyatla.nyartoolkit.as3.markersystem.utils
{
	import jp.nyatla.nyartoolkit.as3.core.NyARException;
	import jp.nyatla.nyartoolkit.as3.core.raster.INyARGrayscaleRaster;
	import jp.nyatla.nyartoolkit.as3.core.types.NyARIntPoint2d;
	import jp.nyatla.nyartoolkit.as3.psarplaycard.PsARPlayCardPickup;

	public class ARPlayCardList_Item extends TMarkerData
	{
		/** Idの情報。 反応するidの開始レンジ*/
		public var nyid_range_s:int;
		/** Idの情報。 反応するidの終了レンジ*/
		public var nyid_range_e:int;
		/** Idの情報。 実際のid値*/
		public var id:int;
		public var dir:int;
		/**
		 * コンストラクタです。初期値から、Idマーカのインスタンスを生成します。
		 * @param i_range_s
		 * @param i_range_e
		 * @param i_patt_size
		 * @throws NyARException
		 */
		public function ARPlayCardList_Item(i_id_range_s:int,i_id_range_e:int,i_patt_size:Number)
		{
			super();
			this.marker_offset.setSquare(i_patt_size);
			this.nyid_range_s=i_id_range_s;
			this.nyid_range_e=i_id_range_e;
			return;
		}		
	}
}