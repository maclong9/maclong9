import config from '$lib/config';
import { json } from '@sveltejs/kit';
import type { RequestHandler } from './$types';

export const GET: RequestHandler = () => {
	return json({
		short_name: config.app.shortName,
		name: config.app.name,
		icons: [
			{
				src: 'favicon.png',
				sizes: '64x64',
				type: 'image/png'
			}
		],
		start_url: '/',
		display: 'standalone'
		// theme_color: customTheme.properties['--color-primary-500'],
		// background_color: customTheme.properties['--color-surface-900']
	});
};
