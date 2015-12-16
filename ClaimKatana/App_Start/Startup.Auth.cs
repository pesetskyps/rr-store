using Microsoft.AspNet.Identity;
using Microsoft.Owin;
using Microsoft.Owin.Security.Cookies;
using Microsoft.Owin.Security.WsFederation;
using Owin;

namespace ClaimKatana
{
    public partial class Startup
    {
        // For more information on configuring authentication, please visit http://go.microsoft.com/fwlink/?LinkId=301864
        public void ConfigureAuth(IAppBuilder app)
        {

            // Enable the application to use a cookie to store information for the signed in user
            app.UseCookieAuthentication(new CookieAuthenticationOptions
            {
                AuthenticationType = DefaultAuthenticationTypes.ApplicationCookie,
                CookieName = "smash-aut",
                AuthenticationMode = Microsoft.Owin.Security.AuthenticationMode.Active,
                LoginPath = new PathString("/Account/Login")
            });

            // Enable the application to use a cookie to store information for the signed in user
            app.Properties["Microsoft.Owin.Security.Constants.DefaultSignInAsAuthenticationType"] = "ExternalCookie";
            app.UseCookieAuthentication(new CookieAuthenticationOptions
            {
                AuthenticationType = "ExternalCookie",
                AuthenticationMode = Microsoft.Owin.Security.AuthenticationMode.Passive
            });

            //configure Antariksh ADFS middleware
            var plexADFS = new WsFederationAuthenticationOptions
            {
                MetadataAddress = "https://antarikshplex.cloudapp.net/FederationMetadata/2007-06/FederationMetadata.xml",
                AuthenticationType = "Plex ADFS",
                Caption = "Plex Domain",
                
                BackchannelCertificateValidator = null,
                //localhost
                Wreply = "https://localhost:44301/Account/LoginCallbackIndiaPlextestAdfs",
                Wtrealm = "https://localhost:44301/Account/LoginCallbackIndiaPlextestAdfs"
            };

            //configure IndiaUniverse ADFS middleware
            var plextestADFS = new WsFederationAuthenticationOptions
            {
                MetadataAddress = "https://plextestad.cloudapp.net/FederationMetadata/2007-06/FederationMetadata.xml",
                AuthenticationType = "Plextest ADFS",
                Caption = "plext test",
                BackchannelCertificateValidator = null,
                //localhost
                Wreply = "https://localhost:44301/Account/LoginCallbackIndiaPlextestAdfs",
                Wtrealm = "https://localhost:44301/Account/LoginCallbackIndiaPlextestAdfs"
            };
            //add to pipeline
            //app.UseWsFederationAuthentication(plexADFS);

            app.Map("/Account", configuration =>
            {
                configuration.UseWsFederationAuthentication(plexADFS);
                configuration.UseWsFederationAuthentication(plextestADFS);
            });

            // Use a cookie to temporarily store information about a user logging in with a third party login provider
            //app.UseExternalSignInCookie(DefaultAuthenticationTypes.ExternalCookie);

            // Uncomment the following lines to enable logging in with third party login providers
            //app.UseMicrosoftAccountAuthentication(
            //    clientId: "",
            //    clientSecret: "");

            //app.UseTwitterAuthentication(
            //   consumerKey: "",
            //   consumerSecret: "");

            //app.UseFacebookAuthentication(
            //   appId: "",
            //   appSecret: "");

            //app.UseGoogleAuthentication();
        }
    }
}