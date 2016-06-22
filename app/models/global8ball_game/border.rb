module Global8ballGame
  class Border
    BORDER_DEFINITION = {
      borders:
        [
          [
            {
              x: 0,
              y: 0
            },
            {
              x: 0,
              y: 0
            },
            {
              x: 0,
              y: 0
            },
            {
              x: 0,
              y: 0
            }
          ],
          [
            {
              x: 0,
              y: 0
            },
            {
              x: 0,
              y: 0
            },
            {
              x: 0,
              y: 0
            },
            {
              x: 0,
              y: 0
            }
          ],
          [
            {
              x: 0,
              y: 0
            },
            {
              x: 0,
              y: 0
            },
            {
              x: 0,
              y: 0
            },
            {
              x: 0,
              y: 0
            }
          ],
          [
            {
              x: 0,
              y: 0
            },
            {
              x: 0,
              y: 0
            },
            {
              x: 0,
              y: 0
            },
            {
              x: 0,
              y: 0
            }
          ],
          [
            {
              x: 0,
              y: 0
            },
            {
              x: 0,
              y: 0
            },
            {
              x: 0,
              y: 0
            },
            {
              x: 0,
              y: 0
            }
          ],
          [
            {
              x: 0,
              y: 0
            },
            {
              x: 0,
              y: 0
            },
            {
              x: 0,
              y: 0
            },
            {
              x: 0,
              y: 0
            }
          ]
        ]
    }

    class << self
      def config
        BORDER_DEFINITION
      end

      def config_json
        self.config.to_json
      end
    end
  end
end
