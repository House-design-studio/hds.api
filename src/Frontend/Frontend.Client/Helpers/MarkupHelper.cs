using Microsoft.AspNetCore.Components;

namespace Frontend.Client.Helpers;

public static class MarkupHelper
{
    public static MarkupString AsMarkup(this string s) => (MarkupString)s;
}