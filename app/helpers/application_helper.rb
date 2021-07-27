module ApplicationHelper
    def space
        # prevent haml whitespace being stripped in staging and production
        # which would lead to elements being stuck together.
        # As in development whitespace is not stripped, it looks good in
        # development even without this helper.
        ' '
      end
end
