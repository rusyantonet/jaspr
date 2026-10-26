import 'package:jaspr/jaspr.dart';
import 'package:jaspr_content/components/sidebar.dart';
import 'package:jaspr_content/jaspr_content.dart';

class AppSidebar extends StatelessComponent {
  const AppSidebar({super.key});

  @override
  Component build(BuildContext context) {
    // Use the current URI path as the route
    final currentRoute = context.page.url;

    if (currentRoute.startsWith('/minelink')) {
      return Sidebar(
        groups: [
          SidebarGroup(
            links: [
              SidebarLink(
                text: 'Overview',
                href: '/minelink',
              ),
              SidebarLink(
                text: 'Quick Start',
                href: '/minelink/quickstart',
              ),
            ],
          ),
                    SidebarGroup(
            title: 'Requirements',
            links: [
              SidebarLink(
                text: 'Tools and Consumables',
                href: '/minelink/requirements/tools',
              ),
              SidebarLink(
                text: 'Devices',
                href: '/minelink/requirements/devices',
              ),
              SidebarLink(
                text: 'Software',
                href: '/minelink/requirements/software',
              ),
              SidebarLink(
                text: 'Network',
                href: '/minelink/requirements/network',
              ),
            ],
          ),

          SidebarGroup(
            title: 'MineMobile',
            links: [
              SidebarLink(
                text: '🛠️Installation',
                href: '/minelink/minemobile/installation',
              ),
              SidebarLink(
                text: '💻Interface',
                href: '/minelink/minemobile/interface',
              ),
              SidebarLink(
                text: '⚙️Server',
                href: '/minelink/minemobile/server',
              ),
            ],
          ),
          
          SidebarGroup(
            title: 'MineDispatch',
            links: [
              SidebarLink(
                text: '🛠️Installation',
                href: '/minelink/minedispatch/installation',
              ),
              SidebarLink(
                text: '⚙️Configuration',
                href: '/minelink/minedispatch/configuration',
              ),
            ],
          ),
        ]);
    }

    if (currentRoute.startsWith('/minesafedrive')) {
      return Sidebar(
        groups: [
          SidebarGroup(

            links: [
              SidebarLink(
                text: 'Overview',
                href: '/minesafedrive',
              ),
              SidebarLink(
                text: 'Architecture',
                href: '/minesafedrive/architecture',
              ),
              SidebarLink(
                text: 'Hardware',
                href: '/minesafedrive/hardware',
              ),
              SidebarLink(
                text: 'Software',
                href: '/minesafedrive/software',
              ),
            ],
          ),
          SidebarGroup(
            title: 'Deployment',
            links: [
              SidebarLink(
                text: 'Installation',
                href: '/minesafedrive/installation',
              ),
              SidebarLink(
                text: 'Configuration',
                href: '/minesafedrive/configuration',
              ),
              SidebarLink(
                text: 'Commissioning',
                href: '/minesafedrive/commissioning',
              ),
            ],
          ),
          SidebarGroup(
            title: 'Operation',
            links: [
              SidebarLink(
                text: 'Network & Integration',
                href: '/minesafedrive/network-integration',
              ),
              SidebarLink(
                text: 'Maintenance',
                href: '/minesafedrive/maintenance',
              ),
              SidebarLink(
                text: 'Troubleshooting',
                href: '/minesafedrive/troubleshooting',
              ),
              SidebarLink(
                text: 'Technical Reference',
                href: '/minesafedrive/technical-reference',
              ),
            ],
          ),
        ],
      );
    }

    if (currentRoute.startsWith('/weighbridge')) {
      return Sidebar(
        groups: [
          SidebarGroup(
            title: 'Weighbridge',
            links: [
              SidebarLink(
                text: 'Overview',
                href: '/weighbridge',
              ),
              SidebarLink(
                text: 'Requirements',
                href: '/weighbridge/requirements',
              ),
            ],
          ),
          SidebarGroup(
            title: 'Diagrams',
            links: [
              SidebarLink(
                text: 'Schematic',
                href: '/weighbridge/diagram/schematic',
              ),
            ],
          ),
        ],
      );
    }

    if (currentRoute.startsWith('/network')) {
      return Sidebar(
        groups: [
          SidebarGroup(
            title: 'Network',
            links: [
              SidebarLink(
                text: 'Overview',
                href: '/network',
              ),
              SidebarLink(
                text: 'MikroTik',
                href: '/network/mikrotik',
              ),
              SidebarLink(
                text: 'Ubiquiti',
                href: '/network/ubiquiti',
              ),
            ],
          ),
        ],
      );
    }

    if (currentRoute.startsWith('/whatever')) {
      return Sidebar(
        groups: [
          SidebarGroup(
            title: 'Whatever',
            links: [
              SidebarLink(
                text: 'Overview',
                href: '/whatever',
              ),
              SidebarLink(
                text: 'Cloud Server STB',
                href: '/whatever/cloud-server-stb',
              ),
              SidebarLink(
                text: 'Web Server STB',
                href: '/whatever/web-server-stb',
              ),
            ],
          ),
        ],
      );
    }

    return Sidebar(
      groups: [
        SidebarGroup(
          title: 'Overview',
          links: [
            SidebarLink(
              text: 'Introduction',
              href: '/',
            ),
            SidebarLink(
              text: 'About',
              href: '/about',
            ),
          ],
        ),
      ],
    );
  }
}