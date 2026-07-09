import 'package:jaspr/jaspr.dart';
import 'package:jaspr/dom.dart';
import 'package:jaspr_content/theme.dart';

class Navbar extends StatelessComponent {
  const Navbar({super.key});

  @override
  Component build(BuildContext context) {
    final location = context.url.toString();

    return div(
      classes: 'navbar',
      [
        a(
          href: '/',
          classes: location == '/' ? 'active' : null,
          [Component.text('Overview')],
        ),
        a(
          href: '/minelink',
          classes: location.startsWith('/minelink') ? 'active' : null,
          [Component.text('MineLink')],
        ),
        a(
          href: '/weighbridge',
          classes: location.startsWith('/weighbridge') ? 'active' : null,
          [Component.text('Weighbridge')],
        ),
        a(
          href: '/network',
          classes: location.startsWith('/network') ? 'active' : null,
          [Component.text('Network')],
        ),
        a(
          href: '/whatever',
          classes: location.startsWith('/whatever') ? 'active' : null,
          [Component.text('Whatever')],
        ),
      ],
    );
  }

  @css
  static List<StyleRule> get styles => [
    css('.navbar').styles(
      display: Display.flex,
      position: Position.fixed(
        top: 4.rem,
        left: Unit.zero,
        right: Unit.zero,
      ),
      zIndex: ZIndex(9),
      height: 2.5.rem,
      padding: Padding.symmetric(horizontal: 1.5.rem),
      border: Border.only(
        bottom: BorderSide(
          width: 1.px,
          color: Color('#0000000d'),
        ),
      ),
      alignItems: AlignItems.center,
      gap: Gap.column(1.25.rem),
      fontSize: 0.875.rem,
      backgroundColor: ContentColors.background,
      raw: {
        'white-space': 'nowrap',
        '-webkit-overflow-scrolling': 'touch',
        'overflow-x': 'auto',
        'overflow-y': 'hidden',
      },
///      raw: {'backdrop-filter': 'blur(5px)',},
    ),

    css('.navbar a').styles(
      display: Display.flex,
      position: Position.relative(),
      height: 2.5.rem,
      transition: Transition(
        'all',
        duration: 150.ms,
        curve: Curve.easeInOut,
      ),
      alignItems: AlignItems.center,
      ///color: Color('#6b7280'),
      fontWeight: FontWeight.w500,
      textDecoration: TextDecoration.none,
    ),

    css('.navbar a:hover').styles(
      border: Border.only(
        bottom: BorderSide(
          width: 1.5.px,
          color: Color('#2563eb'),
        ),
      ),
      color: ContentColors.primary,
    ),

    css('.navbar a.active').styles(
      border: Border.only(
        bottom: BorderSide(
          width: 1.5.px,
          color: Color('#2563eb'),
        ),
      ),
      opacity: 1,
      ///color: Color('#2563eb'),
      color: ContentColors.primary,
      fontWeight: FontWeight.w500,
    ),

    css.media(
      MediaQuery.all(minWidth: 768.px),
      [
        css('.navbar').styles(
          padding: Padding.symmetric(horizontal: 2.5.rem),
        ),
      ],
    ),
  ];
}