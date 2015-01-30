/**********************************************************************************\

	Copyright (c) 2014 Dzianis Rusak

	Permission is hereby granted, free of charge, to any person obtaining a copy
	of this software and associated documentation files (the "Software"), to deal
	in the Software without restriction, including without limitation the rights
	to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
	copies of the Software, and to permit persons to whom the Software is
	furnished to do so, subject to the following conditions:

	The above copyright notice and this permission notice shall be included in
	all copies or substantial portions of the Software.

	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
	IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
	FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
	AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
	LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
	OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
	THE SOFTWARE.

\**********************************************************************************/
window.SelectLikeABoss = window.SelectLikeABoss || (function() {
	var getCurrentAnchor = function(node) {
		if (node.nodeType === 3)
			node = node.parentNode;
		do {
			if (node.constructor === HTMLAnchorElement)
				return node
		} while ((node = node.parentNode) && node !== document.body);
		return null
	};
	var stopEvent = function(e) {
		return e.preventDefault(), e.stopPropagation(), false
	};
	var browser = (function() {
		var w = typeof InstallTrigger === 'undefined';
		return {getRangeFromPoint: function(x, y) {
				if (w) {
					return document.caretRangeFromPoint(x, y)
				} else {
					var range = document.createRange();
					var p = document.caretPositionFromPoint(x, y);
					range.setStart(p.offsetNode, p.offset);
					return range
				}
				return null
			},userSelect: ((w ? '-webkit-' : '-moz-') + 'user-select')}
	})();
	var _letUserSelect = (function() {
		var o = [{p: browser.userSelect,v: 'text'}, {p: 'outline-width',v: 0}];
		var n;
		var s;
		return function(node) {
			if (node) {
				n = node, s = [];
				for (var i = o.length - 1; i >= 0; i -= 1) {
					s.push([n.style.getPropertyValue(o[i].p), n.style.getPropertyPriority(o[i].p)]);
					n.style.setProperty(o[i].p, o[i].v, 'important')
				}
			} else if (n) {
				for (var i = o.length; i-- > 0; ) {
					n.style.removeProperty(o[i].p);
					if (s[i][0] !== null)
						n.style.setProperty(o[i].p, s[i][0], s[i][1])
				}
				n = s = null
			}
		}
	})();
	var _bind = function(evt, bind) {
		if (bind === undefined)
			bind = true;
		if (evt.constructor !== Array)
			evt = [evt];
		var method = bind ? 'addEventListener' : 'removeEventListener';
		for (var i = 0, len = evt.length; i < len; i += 1)
			document[method](evt[i], handlers[evt[i]], true)
	};
	var _unbind = function(evt) {
		_bind(evt, false)
	};
	var cursor;
	var needDetermineUserSelection;
	var userSelecting;
	var needCreateStartSelection;
	var needStopClick;
	var resetVars = function() {
		needDetermineUserSelection = needCreateStartSelection = true;
		userSelecting = needStopClick = false
	};
	var movable;
	var s = document.getSelection();
	var mainMouseDownHandler = function(e) {
		var tagName = e.target.tagName.toUpperCase();
		if (e.which < 2 && tagName === 'A') {
			resetVars();
			var x = e.clientX;
			var y = e.clientY;
			if (s.type === 'Range') {
				var range = browser.getRangeFromPoint(x, y);
				if (range && s.getRangeAt(0).isPointInRange(range.startContainer, range.startOffset))
					return
			}
			_letUserSelect();
			var t = e.target;
			var n = getCurrentAnchor(t);
			if (!n) {
				n = t.nodeType !== 3 ? t : t.parentNode
			}
			if (n.constructor === HTMLTextAreaElement || n.constructor === HTMLCanvasElement || n.textContent === '')
				return;
			var rect = n.getBoundingClientRect();
			movable = {n: n,x: Math.round(rect.left),y: Math.round(rect.top),c: 0};
			cursor = {x: x,y: y};
			_bind(['mousemove', 'mouseup', 'dragend', 'dragstart']);
			_letUserSelect(n)
		}
	};
	var D = 3;
	var K = 0.8;
	var handlers = {'mousemove': function(e) {
			if (movable) {
				if (movable.c++ < 12) {
					var rect = movable.n.getBoundingClientRect();
					if (Math.round(rect.left) !== movable.x || Math.round(rect.top) !== movable.y) {
						_unbind(['mousemove', 'mouseup', 'dragend', 'dragstart', 'click']);
						_letUserSelect();
						s.removeAllRanges();
						return
					}
				} else {
					movable = null
				}
			}
			var x = e.clientX;
			var y = e.clientY;
			if (needCreateStartSelection) {
				s.removeAllRanges();
				var correct = x > cursor.x ? -2 : 2;
				var range = browser.getRangeFromPoint(x + correct, y);
				if (range) {
					s.addRange(range);
					needCreateStartSelection = false
				}
			}
			if (needDetermineUserSelection) {
				var vx = Math.abs(cursor.x - x);
				var vy = Math.abs(cursor.y - y);
				userSelecting = vy === 0 || vx / vy > K;
				if (vx > D || vy > D) {
					needDetermineUserSelection = false;
					needStopClick = true;
					_bind('click')
				}
			}
			if (userSelecting) {
				var range = browser.getRangeFromPoint(x, y);
				if (range)
					s.extend(range.startContainer, range.startOffset)
			}
		},'dragstart': function(e) {
			_unbind('dragstart');
			if (userSelecting)
				return stopEvent(e)
		},'mouseup': function(e) {
			_unbind(['mousemove', 'mouseup', 'dragstart', 'dragend']);
			if (!userSelecting && needStopClick)
				needStopClick = false;
			setTimeout(function() {
				_unbind('click')
			}, 111);
			if (s.type !== 'Range')
				_letUserSelect()
		},'dragend': function(e) {
			_unbind(['dragend', 'mousemove', 'mouseup'])
		},'click': function(e) {
			_unbind('click');
			if (needStopClick)
				return stopEvent(e)
		}};
	var enabled;
	return {toggle: function(is) {
			enabled = is !== undefined ? is : !enabled;
			document[enabled ? 'addEventListener' : 'removeEventListener']('mousedown', mainMouseDownHandler, true);
			if (!enabled)
				_letUserSelect()
		},on: function() {
			this.toggle(true)
		},off: function() {
			this.toggle(false)
		}}
})(window);
window.SelectLikeABoss.on();