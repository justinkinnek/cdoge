$(document).ready(function() {
  if ($("#js-parallax-window").length) {
    parallax();
  }

  var PackeryMode = Isotope.LayoutMode.modes.packery;
  var __resetLayout = PackeryMode.prototype._resetLayout;
  PackeryMode.prototype._resetLayout = function() {
    __resetLayout.call( this );
    // reset packer
    var parentSize = getSize( this.element.parentNode );
    var colW = this.columnWidth + this.gutter;
    this.fitWidth = Math.floor( ( parentSize.innerWidth + this.gutter ) / colW ) * colW;
    this.packer.width = this.fitWidth;
    this.packer.height = Number.POSITIVE_INFINITY;
    this.packer.reset();
  };


  PackeryMode.prototype._getContainerSize = function() {
    // remove empty space from fit width
    var emptyWidth = 0;
    for ( var i=0, len = this.packer.spaces.length; i < len; i++ ) {
      var space = this.packer.spaces[i];
      if ( space.y === 0 && space.height === Number.POSITIVE_INFINITY ) {
        emptyWidth += space.width;
      }
    }

    return {
      width: this.fitWidth - this.gutter,
      height: this.maxY - this.gutter
    };
  };

  // always resize
  PackeryMode.prototype.needsResizeLayout = function() {
    return true;
  };

  $( function() {
    var $container = $('.grid').isotope({
      itemSelector: '.item',
      layoutMode: 'packery',
      packery: {
        columnWidth: 250,
        gutter: 40
      }
    });
  });

});

$(window).scroll(function(e) {
  if ($("#js-parallax-window").length) {
    parallax();
  }
});

function parallax(){
  if( $("#js-parallax-window").length > 0 ) {
    var plxBackground = $("#js-parallax-background");
    var plxWindow = $("#js-parallax-window");

    var plxWindowTopToPageTop = $(plxWindow).offset().top;
    var windowTopToPageTop = $(window).scrollTop();
    var plxWindowTopToWindowTop = plxWindowTopToPageTop - windowTopToPageTop;

    var plxBackgroundTopToPageTop = $(plxBackground).offset().top;
    var windowInnerHeight = window.innerHeight;
    var plxBackgroundTopToWindowTop = plxBackgroundTopToPageTop - windowTopToPageTop;
    var plxBackgroundTopToWindowBottom = windowInnerHeight - plxBackgroundTopToWindowTop;
    var plxSpeed = 0.35;

    plxBackground.css('top', - (plxWindowTopToWindowTop * plxSpeed) + 'px');
  }
}



