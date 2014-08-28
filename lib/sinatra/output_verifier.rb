module OutputHelper
  def verification_tag(verification_word)
    "<p hidden>#{verification_word.to_s}</p>"
  end

  def verify_output(output, verification_word)
    output.include? verification_tag(verification_word)
  end
end
