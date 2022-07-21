namespace website.BusinessLogic.Data
{
    /// <summary>
    /// Режимы нагружения
    /// </summary>
    public enum LoadingModes
    {
        a,
        b,
        v,
        g,
        d,
        e,
        j,
        z,
        k,
        l,
        m
    }

    /// <summary>
    /// Класс условий эксплуатации
    /// </summary>
    public enum Exploitations
    {
        class_1a,
        class_1b,
        class_2,
        class_3,
        class_4a,
        class_4b
    }

    /// <summary>
    /// Материалы балки
    /// </summary>
    public enum BeamMatireals
    {
        plank_k16,
        plank_k24,
        plank_k26,
        lvl_k35,
        lvl_k40,
        lvl_k45
    }
}
