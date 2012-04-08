/* 
 * PROJECT: NyARToolkit(Extension)
 * -------------------------------------------------------------------------------
 * The NyARToolkit is Java edition ARToolKit class library.
 * Copyright (C)2008-2012 Ryo Iizuka
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
package jp.nyatla.nyartoolkit.as3.core.rasterfilter.rgb2gs 
{
	import jp.nyatla.nyartoolkit.as3.core.raster.*;
	import jp.nyatla.nyartoolkit.as3.core.raster.rgb.*;

	public class NyARRgb2GsFilterArtkThFactory
	{
		public static function createDriver(i_raster:INyARRgbRaster):INyARRgb2GsFilterArtkTh
		{
			switch (i_raster.getBufferType())
			{
			case NyARBufferType.INT1D_X8R8G8B8_32:
				return new NyARRgb2GsFilterArtkTh_INT1D_X8R8G8B8_32(i_raster);
			default:
				return new NyARRgb2GsFilterArtkTh_Any(i_raster);
			}
		}
	}
}