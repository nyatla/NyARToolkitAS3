package jp.nyatla.nyartoolkit.as3.rpf.tracker.nyartk.status
	{
	import jp.nyatla.nyartoolkit.as3.NyARException;
	import jp.nyatla.nyartoolkit.as3.core.utils.*;


	public class NyARNewTargetStatusPool extends NyARManagedObjectPool
	{
		/**
		 * コンストラクタです。
		 * @param i_size
		 * poolのサイズ
		 * @throws NyARException
		 */
		public function NyARNewTargetStatusPool(i_size:int)
		{
			super.initInstance_1(i_size);
		}
		/**
		 * @Override
		 */
		protected override function createElement_1():NyARManagedObject
		{
			return new NyARNewTargetStatus(this._op_interface);
		}

	}
}