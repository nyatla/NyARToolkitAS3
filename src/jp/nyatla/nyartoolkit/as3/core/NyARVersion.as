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
package jp.nyatla.nyartoolkit.as3.core
{
	/**
	 * このクラスは、NyARToolkitライブラリのバージョン情報を保持します。
	 */
	public class NyARVersion
	{
		/**モジュール名*/
		public static const MODULE_NAME:String="NyARToolkit";
		/**メジャーバージョン*/
		public static const VERSION_MAJOR:int= 4;
		/**マイナバージョン*/
		public static const VERSION_MINOR:int=1;
		/**タグ*/
		public static const VERSION_TAG:int=2;
		/**バージョン文字列*/
		public static const VERSION_STRING:String=MODULE_NAME+"/"+VERSION_MAJOR+"."+VERSION_MINOR+"."+VERSION_TAG;
	}
}