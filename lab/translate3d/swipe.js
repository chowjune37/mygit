/**
 * javascript swipe效果
 * 主要参考了这个开源库：https://github.com/tenjessy/Swipe
 * @param  {[type]} element [description]
 * @param  {[type]} options [description]
 * @return {[type]}		 [description]
 */
var swipe = function(element, options){
	// 如果没有指定dom标签，返回
	if(!element) return null;
	var _this = this;
	// 获取参数
	// index:当前需要显示的索引
	// speed:切换的速度
	// delay:延迟ms后，自动执行
	// callback:回调
	this.options = options || {};
	this.index = this.options.start_index || 0;
	this.speed = this.options.speed || 300;
	this.delay = this.options.auto || 0;
	this.control = this.options.control;
	this.callback = this.options.callback || function() {};

	// 设置需要touch后切换的各个元素名称
	this.container = element;
	this.element = this.container.children[0];

	// console.log(this.container); // div
	// console.log(this.element); // ul

	this.init();
	this.begin();

	if (this.element.addEventListener) {
		this.element.addEventListener('touchstart', this, false);
		this.element.addEventListener('touchmove', this, false);
		this.element.addEventListener('touchend', this, false);
		this.element.addEventListener('touchcancel', this, false);
		this.element.addEventListener('webkitTransitionEnd', this, false);
		this.element.addEventListener('msTransitionEnd', this, false);
		this.element.addEventListener('oTransitionEnd', this, false);
		this.element.addEventListener('transitionend', this, false);
		window.addEventListener('resize', this, false);
	}
}
swipe.prototype = {
	init : function(){
		var _this = this;
		// 获取需要滑动切换的元素及个数
		this.slides = this.element.children;
		this.length = this.slides.length;

		// 如果需要滑动的个数小于2的话，则不让滑动切换
		if(this.length < 2) return null;

		// 获取宽度
		// 通过this.container来获取
		this.width = Math.ceil(("getBoundingClientRect" in this.container) ? this.container.getBoundingClientRect().width : this.container.offsetWidth);
		// return this.width;
		if(!this.width) return null;

		// 设置element的宽度
		// 方便我们使用CSS3的translate3d来达到切换效果
		this.element.style.width = Math.ceil(this.slides.length * this.width) + 'px';
		// return this.element.style.width;

		// 获取索引
		// 根据索引分别设置每一个需要滑动切换的元素的样式
		// 如果在css当中已经写的话，这里就不需要了任何处理了
		var index = this.slides.length;
		while(index--){
			var el = this.slides[index];
			el.style.width = this.width + 'px';
			// el.style.display = 'table-cell';
			el.style.float = 'left';
			el.style.verticalAlign = 'top';
		}

		// 如果需要显示导航控制模块
		// 并为它们绑定相应的事件
		if (this.control && this.control != undefined) {
			var tmpl = _this.container.getElementsByClassName('slider-control')[0];
			if (!tmpl) tmpl = _this.tmpl();
			// 绑定相应的prev, next事件
			var control = this.container.getElementsByClassName('control');
			for(var i = 0; i < control.length; i++) {
				control[i].addEventListener('click', function(e){
					var target = e.target.getAttribute('class');
					target.indexOf('prev') >= 0 ? _this.prev() : _this.next();
					// 手动控制后，让程序再次自动切换
					_this.resume();
					e.stopPropagation();
				});
			}
		}

		// 正式开始滑动切换
		this.slide(this.index, 0);
	},

	/**
	 * 滑动切换
	 * 当前的index
	 * 速度
	 * 是否自动滑动切换
	 * 滑动后的样式
	 * @return {[type]} [description]
	 */
	slide : function(index, duration){
		var style = this.element.style;

		// 切换的持续时间
		// 如果没有定义的话，默认speed
		if(duration == undefined) {
			duration = this.speed;
		}

		// 设置滑动的过渡延迟时间		
		style.webkitTransitionDuration = style.MozTransitionDuration = style.msTransitionDuration = style.OTransitionDuration = style.transitionDuration = duration + 'ms';

		// 设置X轴的平移距离
		style.MozTransform = style.webkitTransform = 'translate3d(' + -(index * this.width) + 'px,0,0)';
		style.msTransform = style.OTransform = 'translateX(' + -(index * this.width) + 'px)';

		// 设置当前最新索引
		this.index = index;

		// 为当前导航添加效果
		// 主要是为了让用户知道当前是第几屏
		var indicators = this.container.getElementsByClassName('indicators')[0];
		if (indicators) {
			var navigation = indicators.getElementsByTagName('span');
			for(var i = 0; i < navigation.length; i++) {
				navigation[i].removeAttribute('class');
				navigation[this.index].className = 'active';
			}
		}
	},

	/**
	 * 模板
	 * 主要是插入一些导航控制器，方便用户左右切换，并知道当前是第几屏
	 * @return {[type]} [description]
	 */
	tmpl : function() {
		var _this = this;
		var control = document.createElement('div');
		control.className = 'slider-control';

		var indicators = '';
		for (var i = 0; i < _this.length; i++) {
			indicators += '<span></span>';
		}

		var html = [
			'<a href="javascript:void(0);" class="control prev">&lt;</a>',
			'<div class="indicators">' + indicators + '</div>',
			'<a href="javascript:void(0);" class="control next">&gt;</a>',
		].join('');

		control.innerHTML = html;
		this.container.appendChild(control);
	},

	getPos: function() {
		// return current index position
		return this.index;
	},

	prev : function(delay) {
		// 如果存在自动切换的话
		// 需要清除
		this.delay = delay || 0;
		clearTimeout(this.interval);

		// 开始滑动切换
		if (this.index) {
			this.slide(this.index - 1, this.speed);
		} else {
			this.slide(this.length - 1, this.speed);
		}
	},

	next : function(delay){
		// 如果存在自动切换的话
		// 需要清除
		this.delay = delay || 0;
		clearTimeout(this.interval);

		// 如果不是第一位的话，则开始正常滑动
		if (this.index < this.length - 1) {
			this.slide(this.index + 1, this.speed);
		}
		//如果已经滑动到最后一个的话
		//则返回到第一位
		else {
			this.slide(0, this.speed);
		}
	},

	begin : function() {
		var _this = this;
		this.interval = (this.delay) ? setTimeout(function() {
			_this.next(_this.delay);
		}, this.delay) : 0;
	},

	stop: function() {
		this.delay = 0;
		clearTimeout(this.interval);
	},
	
	resume: function() {
		this.delay = this.options.auto || 0;
		this.begin();
	},

	/**
	 * 手势
	 * @param  {[type]} e [description]
	 * @return {[type]}   [description]
	 */
	handleEvent : function(e){
		switch(e.type){
			case 'touchstart' :
				this.onTouchStart(e);
				break;
			case 'touchmove' :
				this.onTouchMove(e);
				break;
			case 'touchend' :
			case 'touchcancel' :
				this.onTouchEnd(e);
				break;

			case 'webkitTransitionEnd':
			case 'msTransitionEnd':
			case 'oTransitionEnd':
			case 'transitionend':
				this.transitionEnd(e);
				break;
			case 'resize' :
				this.init();
				break;
		}
	},

	transitionEnd: function(e) {
		
		if (this.delay) this.begin();

		this.callback(e, this.index, this.slides[this.index]);
	},

	onTouchStart : function(e) {
		// 获取touch目标在页面的X坐标、Y坐标、时间戳
		this.start = {
			pageX: e.touches[0].pageX,
			pageY: e.touches[0].pageY,
			time: Number( new Date() )
		};

		this.isScrolling = undefined;

		this.deltaX = 0;
		this.deltaY = 0;

		// 过渡时间设置为1-0至-1的过渡
		this.element.style.MozTransitionDuration = this.element.style.webkitTransitionDuration = 0;

		// 阻止默认行为
		e.stopPropagation();
	},

	onTouchMove : function(e){
		// 确定当前只有一个手指在触摸滑动
		if(e.touches.length > 1 || e.scale && e.scale !== 1) return;

		this.deltaX = e.touches[0].pageX - this.start.pageX;
		this.deltaY = e.touches[0].pageY - this.start.pageY;

		if ( typeof this.isScrolling == 'undefined') {
			this.isScrolling = !!( this.isScrolling || Math.abs(this.deltaX) < Math.abs(e.touches[0].pageY - this.start.pageY) );
		}

		// 如果用户不是要垂直滚动
		if (!this.isScrolling) {
			e.preventDefault();
			clearTimeout(this.interval);

			this.deltaX = this.deltaX / ( (!this.index && this.deltaX > 0 || this.index == this.length - 1 && this.deltaX < 0 ) ? ( Math.abs(this.deltaX) / this.width + 1 ) : 1 );	
			// var s_X = $('#deltaX');
			// s_X.text(this.deltaX);

			this.element.style.MozTransform = this.element.style.webkitTransform = 'translate3d(' + (this.deltaX - this.index * this.width) + 'px, 0, 0)';
			e.stopPropagation();
		}
	},

	onTouchEnd : function(e){
		// 判断是否滑动切换
		var is_valid_slide = Number(new Date()) - this.start.time < 250 && Math.abs(this.deltaX) > 20 || Math.abs(this.deltaX) > this.width / 2;

		// 判断是否滑过头了
		var is_past_bounds = !this.index && this.deltaX > 0 || this.index == this.length - 1 && this.deltaX < 0;

		if (!this.isScrolling) {
			this.slide( this.index + ( is_valid_slide && !is_past_bounds ? (this.deltaX < 0 ? 1 : -1) : 0 ), this.speed );
		}
		e.stopPropagation();
	}
};