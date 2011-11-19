module SubtitulosDownloader
  class SDException < Exception
  end

  class Timeout < SDException
  end

  class ShowNotFound < SDException
  end

  class MoreThanOneShow < SDException
  end

  class EpisodeNotFound < SDException
  end

  class SeasonNotFound < SDException
  end

  class TranslationNotFinished < SDException
  end

  class LanguageNotFound < SDException
  end
end