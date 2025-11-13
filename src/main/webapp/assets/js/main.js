(function ($) {
    "use strict";
    
    // Dropdown on mouse hover
    $(document).ready(function () {
        function toggleNavbarMethod() {
            if ($(window).width() > 768) {
                $('.navbar .dropdown').on('mouseover', function () {
                    $('.dropdown-toggle', this).trigger('click');
                }).on('mouseout', function () {
                    $('.dropdown-toggle', this).trigger('click').blur();
                });
            } else {
                $('.navbar .dropdown').off('mouseover').off('mouseout');
            }
        }
        toggleNavbarMethod();
        $(window).resize(toggleNavbarMethod);
    });
    
    // Run sliders and UI once DOM is ready to avoid race conditions
    $(function () {
        // Back to top button
        $(window).scroll(function () {
            if ($(this).scrollTop() > 100) {
                $('.back-to-top').fadeIn('slow');
            } else {
                $('.back-to-top').fadeOut('slow');
            }
        });
        $('.back-to-top').click(function () {
            $('html, body').animate({scrollTop: 0}, 1500, 'easeInOutExpo');
            return false;
        });

        // Home page slider
        if ($('.main-slider').length) {
            if (!$('.main-slider').hasClass('slick-initialized')) {
                $('.main-slider').slick({
                    autoplay: true,
                    autoplaySpeed: 4000,
                    speed: 500,
                    dots: true,
                    infinite: true,
                    slidesToShow: 1,
                    slidesToScroll: 1,
                    arrows: true,
                    adaptiveHeight: false,
                    centerMode: false,
                    variableWidth: false,
                    fade: true,
                    cssEase: 'linear'
                });
            }
        }

        // Product Slider 4 Column
        if ($('.product-slider-4').length) {
            if (!$('.product-slider-4').hasClass('slick-initialized')) {
                $('.product-slider-4').slick({
                    autoplay: true,
                    infinite: true,
                    dots: false,
                    slidesToShow: 4,
                    slidesToScroll: 1,
                    responsive: [
                        { breakpoint: 1200, settings: { slidesToShow: 4 } },
                        { breakpoint: 992,  settings: { slidesToShow: 3 } },
                        { breakpoint: 768,  settings: { slidesToShow: 2 } },
                        { breakpoint: 576,  settings: { slidesToShow: 1 } }
                    ]
                });
            }
        }

        // Product Slider 3 Column
        if ($('.product-slider-3').length) {
            if (!$('.product-slider-3').hasClass('slick-initialized')) {
                $('.product-slider-3').slick({
                    autoplay: true,
                    infinite: true,
                    dots: false,
                    slidesToShow: 3,
                    slidesToScroll: 1,
                    responsive: [
                        { breakpoint: 992, settings: { slidesToShow: 3 } },
                        { breakpoint: 768, settings: { slidesToShow: 2 } },
                        { breakpoint: 576, settings: { slidesToShow: 1 } }
                    ]
                });
            }
        }

        // Single Product Slider
        if ($('.product-slider-single').length) {
            if (!$('.product-slider-single').hasClass('slick-initialized')) {
                $('.product-slider-single').slick({
                    infinite: true,
                    dots: false,
                    slidesToShow: 1,
                    slidesToScroll: 1
                });
            }
        }

        // Brand Slider
        if ($('.brand-slider').length) {
            if (!$('.brand-slider').hasClass('slick-initialized')) {
                $('.brand-slider').slick({
                    speed: 1000,
                    autoplay: true,
                    autoplaySpeed: 1000,
                    infinite: true,
                    arrows: false,
                    dots: false,
                    slidesToShow: 5,
                    slidesToScroll: 1,
                    responsive: [
                        { breakpoint: 992, settings: { slidesToShow: 4 } },
                        { breakpoint: 768, settings: { slidesToShow: 3 } },
                        { breakpoint: 576, settings: { slidesToShow: 2 } },
                        { breakpoint: 300, settings: { slidesToShow: 1 } }
                    ]
                });
            }
        }

        // Quantity controls (respect min/max, default min=1)
        $('.qty button').on('click', function () {
            var $button = $(this);
            var $input = $button.parent().find('input');
            var min = parseInt($input.attr('min'), 10);
            var max = parseInt($input.attr('max'), 10);
            if (isNaN(min)) min = 1;
            var oldValue = parseFloat($input.val());
            if (isNaN(oldValue)) oldValue = min;
            var newVal = oldValue;
            if ($button.hasClass('btn-plus')) {
                newVal = oldValue + 1;
                if (!isNaN(max)) newVal = Math.min(newVal, max);
            } else {
                newVal = oldValue - 1;
                newVal = Math.max(newVal, min);
            }
            $input.val(newVal);
        });

        // Shipping address show hide
        $('.checkout #shipto').change(function () {
            if($(this).is(':checked')) {
                $('.checkout .shipping-address').slideDown();
            } else {
                $('.checkout .shipping-address').slideUp();
            }
        });

        // Payment methods show hide
        $('.checkout .payment-method .custom-control-input').change(function () {
            if ($(this).prop('checked')) {
                var checkbox_id = $(this).attr('id');
                $('.checkout .payment-method .payment-content').slideUp();
                $('#' + checkbox_id + '-show').slideDown();
            }
        });
    });

    // Fallback: initialize sliders after all assets are loaded if needed
    $(window).on('load', function () {
        if ($('.main-slider').length && !$('.main-slider').hasClass('slick-initialized')) {
            $('.main-slider').slick({
                autoplay: true,
                autoplaySpeed: 4000,
                speed: 500,
                dots: true,
                infinite: true,
                slidesToShow: 1,
                slidesToScroll: 1,
                arrows: true,
                adaptiveHeight: false,
                centerMode: false,
                variableWidth: false,
                fade: true,
                cssEase: 'linear'
            });
        }
        if ($('.product-slider-4').length && !$('.product-slider-4').hasClass('slick-initialized')) {
            $('.product-slider-4').slick({
                autoplay: true,
                infinite: true,
                dots: false,
                slidesToShow: 4,
                slidesToScroll: 1,
                responsive: [
                    { breakpoint: 1200, settings: { slidesToShow: 4 } },
                    { breakpoint: 992,  settings: { slidesToShow: 3 } },
                    { breakpoint: 768,  settings: { slidesToShow: 2 } },
                    { breakpoint: 576,  settings: { slidesToShow: 1 } }
                ]
            });
        }
        if ($('.product-slider-3').length && !$('.product-slider-3').hasClass('slick-initialized')) {
            $('.product-slider-3').slick({
                autoplay: true,
                infinite: true,
                dots: false,
                slidesToShow: 3,
                slidesToScroll: 1,
                responsive: [
                    { breakpoint: 992, settings: { slidesToShow: 3 } },
                    { breakpoint: 768, settings: { slidesToShow: 2 } },
                    { breakpoint: 576, settings: { slidesToShow: 1 } }
                ]
            });
        }
        if ($('.product-slider-single').length && !$('.product-slider-single').hasClass('slick-initialized')) {
            $('.product-slider-single').slick({
                infinite: true,
                dots: false,
                slidesToShow: 1,
                slidesToScroll: 1
            });
        }
        if ($('.brand-slider').length && !$('.brand-slider').hasClass('slick-initialized')) {
            $('.brand-slider').slick({
                speed: 1000,
                autoplay: true,
                autoplaySpeed: 1000,
                infinite: true,
                arrows: false,
                dots: false,
                slidesToShow: 5,
                slidesToScroll: 1,
                responsive: [
                    { breakpoint: 992, settings: { slidesToShow: 4 } },
                    { breakpoint: 768, settings: { slidesToShow: 3 } },
                    { breakpoint: 576, settings: { slidesToShow: 2 } },
                    { breakpoint: 300, settings: { slidesToShow: 1 } }
                ]
            });
        }
    });

    // AJAX Add to Cart
    $(function () {
        function updateCartCount(count) {
            var $badge = $('.top-header .cart span');
            if ($badge.length) {
                $badge.text('(' + count + ')');
            }
        }
        function showAddedToast() {
            var $toast = $('<div class="toast-notify">Added to cart</div>').appendTo('body');
            $toast.fadeIn(150);
            setTimeout(function () { $toast.fadeOut(300, function(){ $(this).remove(); }); }, 1000);
        }
        $(document).on('click', 'a[href*="/add-to-cart"]', function (e) {
            var href = $(this).attr('href');
            // only intercept if it has productId param
            if (!/productId=\d+/.test(href)) return;
            e.preventDefault();
            $.ajax({
                url: href + (href.indexOf('?') > -1 ? '&' : '?') + 'ajax=1',
                method: 'GET',
                headers: { 'X-Requested-With': 'XMLHttpRequest' }
            }).done(function (res) {
                if (res && res.ok) {
                    if (typeof res.count !== 'undefined') updateCartCount(res.count);
                    showAddedToast();
                } else if (res && res.auth === false) {
                    window.location.href = window.location.origin + (window.appContextPath || '') + '/login.jsp#login';
                } else {
                    // unknown response, fallback to navigation
                    window.location.href = href;
                }
            }).fail(function (xhr) {
                if (xhr && xhr.status === 401) {
                    window.location.href = (window.appContextPath || '') + '/login.jsp#login';
                } else {
                    // fallback to normal navigation on error
                    window.location.href = href;
                }
            });
        });

        // Ensure top header account dropdown toggles
        $(document).on('click', '.top-header .dropdown > a.dropdown-toggle', function (e) {
            e.preventDefault();
            e.stopPropagation();
            var $toggle = $(this);
            // Close other open dropdowns in the area
            $('.top-header .dropdown .dropdown-menu.show').removeClass('show');
            // Toggle this one via class if plugin not bound
            var $menu = $toggle.siblings('.dropdown-menu');
            if ($menu.length) {
                $menu.toggleClass('show');
            }
            // Also try Bootstrap API if available
            if ($.fn.dropdown) {
                try { $toggle.dropdown('toggle'); } catch (err) { /* noop */ }
            }
            return false;
        });
        // Close when clicking anywhere else
        $(document).on('click', function(){
            $('.top-header .dropdown .dropdown-menu').removeClass('show');
        });

        // Generic dropdown fallback for elements with data-toggle="dropdown" (e.g., sort-by in product list)
        if (!$.fn.dropdown) {
            $(document).on('click', '[data-toggle="dropdown"]', function(e){
                e.preventDefault();
                e.stopPropagation();
                var $toggle = $(this);
                var $menu = $toggle.siblings('.dropdown-menu');
                // close others
                $('.dropdown .dropdown-menu.show').not($menu).removeClass('show');
                if ($menu.length) {
                    $menu.toggleClass('show');
                }
                return false;
            });
            $(document).on('click', function(){
                $('.dropdown .dropdown-menu.show').removeClass('show');
            });
        }
    });
})(jQuery);

/* lightweight styles for toast */
(function(){
  var css = '.toast-notify{position:fixed;right:16px;bottom:16px;background:#28a745;color:#fff;padding:8px 12px;border-radius:4px;box-shadow:0 2px 8px rgba(0,0,0,.2);display:none;z-index:9999;font-size:14px;}';
  var s = document.createElement('style'); s.type='text/css'; s.appendChild(document.createTextNode(css));
  document.head.appendChild(s);
})();

/* Lazy-load product images with placeholder shown first */
(function(){
  var placeholder = (window.appContextPath || '') + '/assets/img/placeholder.jpg';
  function loadImg($img){
      var dataSrc = $img.attr('data-src');
      if (!dataSrc) return;
      // preload to catch errors before swapping
      var pre = new Image();
      pre.onload = function(){ $img.attr('src', dataSrc).removeAttr('data-src'); };
      pre.onerror = function(){ $img.attr('src', placeholder); };
      pre.src = dataSrc;
  }
  var $lazy = $('img.lazy-img');
  if ('IntersectionObserver' in window) {
      var io = new IntersectionObserver(function(entries){
          entries.forEach(function(entry){
              if (entry.isIntersecting) {
                  var $img = $(entry.target);
                  loadImg($img);
                  io.unobserve(entry.target);
              }
          });
      }, { rootMargin: '100px 0px' });
      $lazy.each(function(){ io.observe(this); });
  } else {
      // Fallback: load immediately
      $lazy.each(function(){ loadImg($(this)); });
  }
})();
