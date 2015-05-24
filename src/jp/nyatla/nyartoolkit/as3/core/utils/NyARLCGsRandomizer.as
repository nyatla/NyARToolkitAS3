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
package jp.nyatla.nyartoolkit.as3.core.utils 
{
	import jp.nyatla.as3utils.*;
	import jp.nyatla.nyartoolkit.as3.core.transmat.rotmatrix.NyARRotVector;
	import jp.nyatla.nyartoolkit.as3.core.*;

	public class NyARLCGsRandomizer
	{
		protected var _rand_val:Number;
		protected var _seed:int;
		public function NyARLCGsRandomizer(i_seed:int)
		{
			this._seed=i_seed;
			this._rand_val=i_seed;
		}
		public function setSeed(i_seed:int):void
		{
			this._rand_val=i_seed;
		}
		public function rand():int
		{
			this._rand_val = (this._rand_val * 214013 + 2531011);
			return int((this._rand_val /65536) & RAND_MAX);
			
		}
		public static const RAND_MAX:int=0x7fff;
	}
}
