import { Controller } from 'stimulus'

class SlideController extends Controller {
  static targets = ['open']

  connect() {
    console.log('Slide Controller works!')
  }

  start(event) {
    let touch = event.targetTouches[0]
    this.startPos = {
      x: touch.pageX,
      y: touch.pageY
    }
  }

  // data-action="touchmove->slide#move touchstart->slide#start"
  move(event) {
    let ele = event.currentTarget

    if (event.targetTouches.length > 1 || event.scale && event.scale !== 1) {
      return
    }
    let touch = event.targetTouches[0]
    let offset = {
      x: touch.pageX - this.startPos.x,
      y: touch.pageY - this.startPos.y
    }
    console.log(offset)
    let pad = Math.abs(offset.x)
    let isMore = pad > this.element.clientWidth / 2 ? 1 : 0
    let isScrolling = pad < Math.abs(offset.y) ? 1 : 0
    if (isScrolling === 0 && offset.x < 0) {
      event.preventDefault()
      let next = ele.nextElementSibling
      if (next && isMore) {
        ele.style.right = this.element.clientWidth + 'px'
        next.style.left = 0
      } else if (next) {
        ele.style.right = pad + 'px'
        next.style.left = (this.element.clientWidth - pad) + 'px'
      }
    } else if (isScrolling === 0 && offset.x > 0) {
      event.preventDefault()
      let prev = ele.previousElementSibling
      if (prev) {
        ele.style.left = pad + 'px'
        prev.style.right = (this.element.clientWidth - pad) + 'px'
      }
    }
  }

  // data-action="touchend->slide#end"
  end(event) {
    let ele = event.currentTarget
    ele.style.transitionProperty = 'left'
    ele.style.transitionDuration = '1s'
  }

  get index() {
    this.data.get('index')
  }

  get startPos() {
    let r = this.data.get('startPos').split(',')
    return {
      x: parseFloat(r[0]),
      y: parseFloat(r[1])
    }
  }

  set startPos(pos) {
    this.data.set('startPos', [pos.x, pos.y].join(','))
  }

}

application.register('slide', SlideController)
