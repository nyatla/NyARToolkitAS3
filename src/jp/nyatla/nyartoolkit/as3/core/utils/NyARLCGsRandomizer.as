
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
