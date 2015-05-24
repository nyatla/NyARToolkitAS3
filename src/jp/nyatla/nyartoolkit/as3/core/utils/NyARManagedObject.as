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
	/**
	 * NyARManagedObjectPoolの要素クラスです。
	 *
	 */
	public class NyARManagedObject
	{
		/**
		 * オブジェクトの参照カウンタ
		 */
		private var _count:int;
		/**
		 * オブジェクトの解放関数へのポインタ
		 */
		private var _pool_operater:INyARManagedObjectPoolOperater;
		/**
		 * NyARManagedObjectPoolのcreateElement関数が呼び出すコンストラクタです。
		 * @param i_ref_pool_operator
		 * Pool操作の為のインタフェイス
		 */
		public function NyARManagedObject(i_ref_pool_operator:INyARManagedObjectPoolOperater)
		{
			this._count=0;
			this._pool_operater=i_ref_pool_operator;
		}
		public function initObject():NyARManagedObject
		{
			//assert(this._count==0);
			this._count=1;
			return this;
		}
		/**
		 * このオブジェクトに対する、新しい参照オブジェクトを返します。
		 * @return
		 */
		public function referenceObject():NyARManagedObject
		{
			//assert(this._count>0);
			this._count++;
			return this;
		}
		/**
		 * 参照オブジェクトを開放します。
		 * @return
		 */
		public function releaseObject():int
		{
			//assert(this._count>0);
			this._count--;
			if(this._count==0){
				this._pool_operater.deleteObject(this);
			}
			return this._count;
		}
		/**
		 * 現在の参照カウンタを返します。
		 * @return
		 */
		public function getCount():int
		{
			return this._count;
		}
	}
}