package jp.nyatla.nyartoolkit.as3.rpf.tracker.nyartk.status
{

	import jp.nyatla.nyartoolkit.as3.core.*;
	import jp.nyatla.nyartoolkit.as3.core.utils.*;



	/*
	 * 輪郭情報を保管します。
	 * このクラスの要素は、他の要素から参照する可能性があります。
	 */
	public final class NyARContourTargetStatusPool extends NyARManagedObjectPool
	{	
		/**
		 * @param i_size
		 * スタックの最大サイズ
		 * @throws NyARException
		 */
		public function NyARContourTargetStatusPool(i_size:int)
		{
			super.initInstance_1(i_size);
		}
		/**
		 * @Override
		 */
		protected override function createElement_1():NyARManagedObject
		{
			return new NyARContourTargetStatus(this._op_interface);
		}
	}
}