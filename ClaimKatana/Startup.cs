using Microsoft.Owin;
using Owin;

[assembly: OwinStartupAttribute(typeof(ClaimKatana.Startup))]
namespace ClaimKatana
{
    public partial class Startup
    {
        public void Configuration(IAppBuilder app)
        {
            ConfigureAuth(app);
        }
    }
}
