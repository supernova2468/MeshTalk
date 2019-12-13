import trio
from kivy_app import OMSATApp


async def main() -> None:
    async with trio.open_nursery() as nursery:

        async def gui_run_wrapper() -> None:
            await OMSATApp().async_run(async_lib='trio')
            nursery.cancel_scope.cancel()

        nursery.start_soon(gui_run_wrapper)
        # start whatever else is needed here with nursery


if __name__ == '__main__':
    trio.run(main)
